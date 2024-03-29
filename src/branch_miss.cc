#include "branch_miss.h"
#include <mpi.h>
#include <random>

using namespace llvm;

template<typename T, typename V>
requires (std::is_integral_v<T>, std::is_integral_v<V>)
[[gnu::pure, nodiscard]]
inline auto getKey(const auto x, const auto y) noexcept -> auto { return x ^ y; }

[[nodiscard]]
inline auto getRand() noexcept -> double {
  std::random_device rd{};
  std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
  std::default_random_engine Generator{rd()};
  return Distribution(Generator);
}

[[nodiscard]]
auto MCPredictionMissRate::isTerminatingBlock(const BasicBlock& bb, const BasicBlock& front) noexcept -> BlockType {

  if(successors(&bb).empty()) {
    // If the function only has a single basic block, then simply return false. We don't care about it
    if(&bb == &front) {
      dbgs() << "No usable basic blocks in function.\n";
      return BlockType::EMPTY;
      // else if current block isn't the first block, it's a regular terminating block. Increase the looop count and go back to the start of the function
    } else { 
      return BlockType::TERM;
    }
  }
  return BlockType::NORM;
}

[[nodiscard]]
auto MCPredictionMissRate::getBlockMissRate(const BasicBlock& bb, const std::unordered_map<int, ps>& pb) noexcept -> float {
  auto res { 0.0 };
  for(auto j : successors(&bb)) {
    // Index into probability for a given pair of blocks is &B1 XOR &B2
    auto key = getKey<uint64_t, uint64_t>(reinterpret_cast<uint64_t>(&bb), reinterpret_cast<uint64_t>(j));
    auto br = pb.find(key);
    if(br->second.hits == br->second.hits + br->second.misses) {
      continue;
    }
    res += static_cast<double>(br->second.prob_prev *    /* Pbb(i) */
                              br->second.prob_cur *     /* Π(i)(j) */
                              /* Pmis-predict(i)(j) */
                              (static_cast<double>(br->second.misses) / static_cast<double>(br->second.misses + br->second.hits)));   
  }
  return res;
}

[[nodiscard("Chosen successor block is to be compared with predicted successor block.")]]
auto MCPredictionMissRate::getActualSuccessor(const BasicBlock& bb, const BranchProbabilityInfo& bp) noexcept -> std::tuple<const BasicBlock*, uint32_t> {
  auto start = 0.0f;
  auto count = 0;
  auto rand = getRand();
  // Use that random number to select a successor "Actual"
  for(auto succ : successors(&bb)) {
    auto edgeProbs = bp.getEdgeProbability(&bb, succ);
    float end = start + static_cast<float>(edgeProbs.getNumerator()) / (edgeProbs.getDenominator());
    if(rand >= start && rand < end) {
      return std::make_tuple(succ, count);
    }
    count++;
    start = end;
  }
  return std::make_tuple(nullptr, count);
}

auto MCPredictionMissRate::run(Function &F, llvm::FunctionAnalysisManager&) {
  auto loop_count = 0;
  auto cur = &F.getEntryBlock();
  const auto front = cur;
  BasicBlock *prev = const_cast<BasicBlock*>(cur);

  // Optimize for non-leader nodes: The leader only does it's work after receiving info,
  // and there are going to be more non-leaders.
  auto res = 0.0;
  std::unordered_map<int, ps> probabilityTable;
  while(loop_count < tests) {
    Circuit pred{};
    // check if it's a terminating block
    auto tb = isTerminatingBlock(*cur, *front);
    if(tb == BlockType::EMPTY) [[unlikely]] {
      return PreservedAnalyses::all();
    } else if(tb == BlockType::TERM) {
      loop_count++;
      cur = const_cast<BasicBlock*>(front);
      continue;
    }

    auto prob = BranchProbabilityInfo();
    // Get actual successor and if it's the first or second branch (count)
    auto [next, count] = getActualSuccessor(*cur, prob);
    // Get predicted successor
    auto pred_res = pred.predict(cur, count);
    // update the map of cur -> successor branch info
    for(auto succ : successors(cur)) {
      // Get the current branch to successor probability
      auto edgeProbsCur = prob.getEdgeProbability(cur, succ);
      auto p = static_cast<double>(edgeProbsCur.getNumerator()) / (edgeProbsCur.getDenominator());
      // Get the previous branch to current probability
      auto edgeProbsPrev = prob.getEdgeProbability(prev, cur);
      auto pp = static_cast<double>(edgeProbsPrev.getNumerator()) / (edgeProbsPrev.getDenominator());

      auto tmp = ps();
      tmp.prob_cur = p;
      if(pp == 0) pp = 1;
      tmp.prob_prev = pp;
      
      auto key = getKey<uint64_t, uint64_t>(reinterpret_cast<uint64_t>(cur), reinterpret_cast<uint64_t>(succ));
      auto ps_found = probabilityTable.find(key);     
      if(ps_found == probabilityTable.end()) {
        probabilityTable.insert(std::make_pair(key, tmp));
        break;
      }
      auto ps = probabilityTable.find(key);
      ps->second.n_arrives++;
      if(next == succ && pred_res) {
        ps->second.hits++;
      } else if (next != succ && !pred_res) {
        ps->second.misses++;
      }
    }
    prev = const_cast<BasicBlock*>(cur);
    cur = const_cast<BasicBlock*>(next);
  }
  for(auto &i : F) {
    res += getBlockMissRate(i, probabilityTable);
  }
  dbgs() << "Miss Rate (%) : " << (res) << "\n";
  return llvm::PreservedAnalyses::all();
}

llvm::PassPluginLibraryInfo getMCBranchMissInfo() {
  return {LLVM_PLUGIN_API_VERSION, "MCBranchMiss", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "mc-branch-miss") {
                    FPM.addPass(MCPredictionMissRate());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getMCBranchMissInfo();
}
