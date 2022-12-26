#include "branch_miss.h"
#include <chrono>
#include <random>
#include <type_traits>

using namespace llvm;
  
bool MCPredictionMissRate::correlation(const BasicBlock* cur, uint32_t count) noexcept {

  // take the address of the current block
  auto history = corBHT.find(cur);
  if((history == corBHT.end())) {
    corBHT.insert(std::pair<const BasicBlock*, int>(cur, 0b11111111));
  }
  // use the address to index the history table
  history = corBHT.find(cur);
  // Use the history itself (0110101010) as the index to a saturating counter
  auto res = corBPT.find(history->second);
  if((res == corBPT.end())) {
    corBPT.insert(std::pair<uint8_t, uint32_t>(history->second, 4));
  }
  res = corBPT.find(history->second);

  // after prediction, check actual outcome
  // if branch is actually taken, and predicted to be Taken
  if(!count && res->second > 1) {
    hits++;
    //update the saturation counter
    if(res->second < 3)
      res->second++;

    //update the history value
    // shift the history to the left, and add the outcome (1, 0) to the least significant bit
    history->second = (history->second << 1) | 0b00000001;
    return true;
  }
  // if branch is actually taken but not predicted to be taken
  if(!count && res->second < 2) {
    misses++;
    if(res->second < 3)
      res->second++;
    history->second = (history->second << 1) | 0b00000001;
    return false;
  }
  // if branch is not taken but predicted to be taken
  if(count && res->second > 1) {
    misses++;
    if(res->second > 0)
      res->second--;
    history->second = (history->second << 1) ;
    return false;
  }
  // if branch is not taken and is not predicted to be taken
  if(count && res->second < 2) {
    hits++;
    if(res->second > 0)
      res->second--;
    history->second = (history->second) ;
    return true;
  } 

  return true;

}

bool MCPredictionMissRate::saturating2Bit(const BasicBlock* cur, uint32_t count) noexcept {

  // In the counter, keep track of the successor. The rate is per successor per original.
  // The total mis-prediction rate is for each block i for each of its successors j
  // map.find(i->j) = mis-prediction/rate information of i to j

  auto bbprob = blockProbs.find(cur);
  if((bbprob == blockProbs.end())) {
    blockProbs.insert(std::pair<const BasicBlock *, Probability>(cur, Probability()));
  }
  bbprob = blockProbs.find(cur);

  auto found = satBHT.find(cur);
  if((found == satBHT.end())) {
    satBHT.insert(std::pair<const BasicBlock*, int>(cur, 4));
  }
  found = satBHT.find(cur);
// If the branch is taken 'actual' and predicted to be strong or weak TAKEN
  if(!count && found->second > 1) {
    hits++; 
    bbprob->second.hits++;
    if(found->second < 3){
      found->second++;
    }
    return true;
  // if the branch is not taken 'actual' and predicted to be strong or weak TAKEN
  } else if(count == 1 && (found->second > 1)) {
    misses++;
    bbprob->second.misses++;
    if(found->second){
      found->second--;
    }
    return false;
  // if the branch is not taken 'actual' and predicted to be strong or weak NOT TAKEN
  } else if (count == 1 && found->second < 2) {
    // check for underflow
    if(found->second){
      found->second--;
    }
    bbprob->second.hits++;
    hits++;
    return true;
  // if the branch is taken 'actual' and predicted to be strog or weak NOT TAKEN
  } else if (!count && found->second <2) {
    misses++;
    bbprob->second.misses++;
    if(found->second < 3){
      found->second++;
    }
    return false;
  }

  return true;
}

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
      float end; 
      end = start + static_cast<float>(edgeProbs.getNumerator()) / (edgeProbs.getDenominator());
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

    auto res = correlation(cur, count);

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
  double miss_rate = 0.0f;
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
