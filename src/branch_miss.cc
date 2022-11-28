#include "branch_miss.h"

using namespace llvm;
  

void MCPredictionMissRate::saturating2Bit(const BasicBlock* cur, uint32_t count) noexcept {
    auto found = BHT.find(cur);
    if((found == BHT.end())) {
      BHT.insert(std::pair<const BasicBlock*, int>(cur, 4));
    }
    found = BHT.find(cur);
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
  for(uint64_t i = 0; i < CHECKS; i++) {
;
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
    // Do the prediction part
    /* This part will be modular soon to allow different prediction models
     * Starting off with 2 bit saturation counter
     */

    // br expr1 branch1 expr2 branch2
    // if branch1 is predicted, then set move it up, then move the instruction's state machine to taken
    //
    //
    // If the BHT has no record of the branch/Current block, add it with the value of strongly taken (3)
    // Done before work to simulate default behaviour
    saturating2Bit(cur, count);
    

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
