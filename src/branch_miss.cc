#include "branch_miss.h"
#include <chrono>
#include <random>
#include <type_traits>

using namespace llvm;
  
#define CHECKS 100000
bool MCPredictionMissRate::runOnFunction(Function &F) {
  
  std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
  std::default_random_engine Generator(std::chrono::system_clock::now().time_since_epoch().count());


  srand(time(0));
 
  std::unordered_map<int, ps> probabilityTable;

  errs() << "===/ Scanning Function: " << F.getName() << "\n";

  const auto &Blocks = F.getBasicBlockList();

  int loop_count{};

  auto cur = &Blocks.front();
  BasicBlock *prev = const_cast<BasicBlock*>(cur);
  // loop until you reach the full checks
  while(loop_count < CHECKS) {
    
    Correlation pred{};
    float rand = Distribution(Generator);

    // check if it's a terminating block
    if(auto Succs = successors(cur).empty()) {
    // If the function only has a single basic block, then simply return false. We don't care about it
      if(cur == &Blocks.front()) {
        errs() << "No usable basic blocks in function.\n";
        return false;
        // else if current block isn't the first block, it's a regular terminating block. Increase the looop count and go back to the start of the function
      } else { 
        loop_count++;
        cur = &Blocks.front();
        continue;
      }
    }

    auto start = 0.0f;
    auto next = cur;

    auto count = 0;

    auto prob = BranchProbabilityInfo();
    // Generate a random number to use for this block as the definite point in a probability distribution
    // Use that random number to select a successor "Actual"
    for(auto succ : successors(cur)) {
      auto edgeProbs = prob.getEdgeProbability(cur, succ);
      float end = start + static_cast<float>(edgeProbs.getNumerator()) / (edgeProbs.getDenominator());
      // errs() << start << " ... " << end << "\n";
      // errs() <<  " rand =  " << rand << "\n";
      if(rand >= start && rand < end) {
        next = succ;
        // errs() << "chose basic block : " << count << "\n";
        break;
      }
      count++;
      start = end;
    }

    auto res = pred.predict(cur, count);

    // errs() << prev << " == " << cur << "\n";

    // update the map of cur -> successor branch info
    for(auto succ : successors(cur)) {
      // Get the current branch to successor probability
      auto edgeProbsCur = prob.getEdgeProbability(cur, succ);
      auto p = static_cast<float>(edgeProbsCur.getNumerator()) / (edgeProbsCur.getDenominator());
      // Get the previous branch to current probability
      auto edgeProbsPrev = prob.getEdgeProbability(prev, cur);
      auto pp = static_cast<float>(edgeProbsPrev.getNumerator()) / (edgeProbsPrev.getDenominator());

      auto key = reinterpret_cast<uint64_t>(cur) ^ reinterpret_cast<uint64_t>(succ);
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
      if(next == succ && res) {
        ps->second.hits++;
      } else if (next != succ && !res) {
        ps->second.misses++;
      }

    }

    prev = const_cast<BasicBlock*>(cur);
    cur = next;
  }
  double miss_rate = 0.000001f;
  auto Prob = BranchProbabilityInfo();
  for(auto &i : Blocks) {
    for(auto j : successors(&i)) {
      // The probability from the cfg info  
      auto key = reinterpret_cast<uint64_t>(&i) ^ reinterpret_cast<uint64_t>(j);
      auto br = probabilityTable.find(key);
      if(br->second.hits == br->second.hits + br->second.misses) {
        continue;
      }
      errs() << "Branch " << &i << " to " << j << ": " << br->second.hits << "/" << br->second.misses + br->second.hits << "\n";
      errs() << "Prob cur:" << br->second.prob_cur << ". Prob Prev:  " << br->second.prob_prev << "\n";
      miss_rate += static_cast<double>(br->second.prob_prev * br->second.prob_cur * (static_cast<double>(br->second.misses) / static_cast<double>(br->second.misses + br->second.hits)));
    }
  }

  errs() << "Miss Rate (%) : " << (miss_rate) << "\n";
  return false;
}

char MCPredictionMissRate::ID = 0;
static RegisterPass<MCPredictionMissRate> X("mc-branch-miss", "Monte-Carlo branch prediction miss rate simulation",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
