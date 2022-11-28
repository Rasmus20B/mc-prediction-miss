#include "branch_miss.h"

using namespace llvm;
  
void MCPredictionMissRate::correlation(const BasicBlock* cur, uint32_t count) noexcept {

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
  }
  // if branch is actually taken but not predicted to be taken
  if(!count && res->second < 2) {
    misses++;
    if(res->second < 3)
      res->second++;
    history->second = (history->second << 1) | 0b00000001;
  }
  // if branch is not taken but predicted to be taken
  if(count && res->second > 1) {
    misses++;
    if(res->second > 0)
      res->second--;
    history->second = (history->second << 1) ;
  }
  // if branch is not taken and is not predicted to be taken
  if(count && res->second < 2) {
    hits++;
    if(res->second > 0)
      res->second--;
    history->second = (history->second) ;
  } 

  return;

}

void MCPredictionMissRate::saturating2Bit(const BasicBlock* cur, uint32_t count) noexcept {
  auto found = satBHT.find(cur);
  if((found == satBHT.end())) {
    satBHT.insert(std::pair<const BasicBlock*, int>(cur, 4));
  }
  found = satBHT.find(cur);
// If the branch is taken 'actual' and predicted to be strong or weak TAKEN
  if(!count && found->second > 1) {
    hits++; 
    if(found->second < 3){
      found->second++;
    }
  // if the branch is not taken 'actual' and predicted to be strong or weak TAKEN
  } else if(count == 1 && (found->second > 1)) {
    misses++;
    if(found->second){
      found->second--;
    }
  // if the branch is not taken 'actual' and predicted to be strong or weak NOT TAKEN
  } else if (count == 1 && found->second < 2) {
    // check for underflow
    if(found->second){
      found->second--;
    }
    hits++;
  // if the branch is taken 'actual' and predicted to be strog or weak NOT TAKEN
  } else if (!count && found->second <2) {
    misses++;
    if(found->second < 3){
      found->second++;
    }
  }
  return;
}
#define CHECKS 1000000
bool MCPredictionMissRate::runOnFunction(Function &F) {
  std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
  std::default_random_engine Generator;
  float nums[CHECKS] = {0};

  for(auto &i : nums) {
    i = Distribution(Generator);
  }

  errs() << "===/ Scanning Function: " << F.getName() << "\n";


  const auto &Blocks = F.getBasicBlockList();
  auto cur = &Blocks.front();

#pragma omp parallel for
  for(uint64_t i = 0; i < CHECKS; i++) {

    errs() << "Scanning BB : " << cur << "\n";
    //Check if the Block is a terminating block
    if(auto Succs = successors(cur).empty()) {
      //Terminating block of the function
      if(cur == &Blocks.front()){
        return false;
      }
      cur = &Blocks.front();
      // errs() << "No successors to this block\n";
    }
    // Gets Probability info for the Block
    auto Prob = BranchProbabilityInfo();
    auto Start = 0.0f;
    auto next = cur;
    // Used to check if the branch is take or not
    auto count = 0;
    // Get the current basic block's successors
    for(auto Succ: successors(cur)) {
      // For each Successor block, compare random number with probability range to select an 'Actual' chosen Successor
      auto EdgeProbs = Prob.getEdgeProbability(cur, Succ); 
      float End;
      End = Start + static_cast<float>(EdgeProbs.getNumerator()) / (EdgeProbs.getDenominator());
      errs() << "checking Successor : " << *(&Succ) << " with range [" << Start << "," << End << "]\n";
      if(nums[i] >= Start && nums[i] < End) {
        errs() << cur << " chose: " << *(&Succ) << "\n";
        next = Succ;
        break;
      }
      count++;
      Start = End;
    }
    correlation(cur, count);
    

    cur = next;
  }

  errs() << "misses: " << misses << "\n";
  errs() << "hits: " << hits << "\n";
  errs() << "Miss Rate (%): " << static_cast<int>((misses/ (misses + hits)) * 100) << "\n";
  return false;
}

char MCPredictionMissRate::ID = 0;
static RegisterPass<MCPredictionMissRate> X("mc-branch-miss", "Monte-Carlo branch prediction miss rate simulation",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
