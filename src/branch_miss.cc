

#include "branch_miss.h"
#include <x86_64-pc-linux-gnu/mpi.h>


using namespace llvm;

[[gnu::pure]]
inline auto getKey(auto x, auto y) noexcept -> auto { return x ^ y; }

inline auto getRand() noexcept -> double {
  std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
  std::default_random_engine Generator(std::chrono::system_clock::now().time_since_epoch().count());
  return Distribution(Generator);
}

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

auto MCPredictionMissRate::getBlockMissRate(const BasicBlock& bb, const std::unordered_map<int, ps> pb) noexcept -> float {
  auto res { 0.0 };
  for(auto j : successors(&bb)) {
    // Index into probability for a given pair of blocks is &B1 XOR &B2
    auto key = getKey(reinterpret_cast<uint64_t>(&bb), reinterpret_cast<uint64_t>(j));
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

auto MCPredictionMissRate::doInitialization(Module &M) -> bool {
  MPI_Init(nullptr, nullptr);
  return true;
}

auto MCPredictionMissRate::doFinalization(Module &M) -> bool {
  MPI_Finalize();
  return true;
}
auto MCPredictionMissRate::runOnFunction(Function &F) -> bool {
  int world_rank;
  int world_size;
  const auto &Blocks = F.getBasicBlockList();
  auto loop_count = 0;
  auto cur = &Blocks.front();
  BasicBlock *prev = const_cast<BasicBlock*>(cur);

  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
  if(world_rank != 0) {
    auto res = 0.0;
    std::unordered_map<int, ps> probabilityTable;
    while(loop_count < tests) {
      Correlation pred{};
      // check if it's a terminating block
      auto tb = isTerminatingBlock(*cur, Blocks.front());
      if(tb == BlockType::EMPTY){
        MPI_Send(&res, 1, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);
        return true;
      } else if(tb == BlockType::TERM) {
        loop_count++;
        cur = &Blocks.front();
        continue;
      }

      auto prob = BranchProbabilityInfo();
      // Get actual successor and if it's the first of second branch (count)
      auto [next, count] = getActualSuccessor(*cur, prob);
      // Get predicted successor
      auto pred_res = pred.predict(cur, count);
      // update the map of cur -> successor branch info
      for(auto succ : successors(cur)) {
        // Get the current branch to successor probability
        auto edgeProbsCur = prob.getEdgeProbability(cur, succ);
        auto p = static_cast<float>(edgeProbsCur.getNumerator()) / (edgeProbsCur.getDenominator());
        // Get the previous branch to current probability
        auto edgeProbsPrev = prob.getEdgeProbability(prev, cur);
        auto pp = static_cast<float>(edgeProbsPrev.getNumerator()) / (edgeProbsPrev.getDenominator());

        auto key = getKey(reinterpret_cast<uint64_t>(cur), reinterpret_cast<uint64_t>(succ));
        auto tmp = ps();
        
        tmp.prob_cur = p;
        if(pp == 0) pp = 1;
        tmp.prob_prev = pp;

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
      cur = next;
    }
    for(auto &i : Blocks) {
      res += getBlockMissRate(i, probabilityTable);
    }
    MPI_Send(&res, 1, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD);
  } else {
    std::vector<double> res_list(world_size);
    for(auto i = 0; i < world_size - 1; ++i) {
      MPI_Recv(&res_list[i], world_size, MPI_DOUBLE, MPI_ANY_SOURCE, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
      dbgs() << "received " << i << " with  result = " << res_list[i] << "\n";
    }

    auto sum = std::accumulate(res_list.begin(), res_list.end(), 0.0, std::plus<double>());
    auto final_res = sum / (world_size - 1);
    dbgs() << "Miss Rate (%) : " << (final_res) << "\n";
  }
  return true;
}

char MCPredictionMissRate::ID = 0;
static RegisterPass<MCPredictionMissRate> X("mc-branch-miss", "Monte-Carlo branch prediction miss rate simulation",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
