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
  // if the branch is not taken 'actual' and predicted to be strong or weak TAKEN
  } else if(count == 1 && (found->second > 1)) {
    misses++;
    bbprob->second.misses++;
    if(found->second){
      found->second--;
    }
  // if the branch is not taken 'actual' and predicted to be strong or weak NOT TAKEN
  } else if (count == 1 && found->second < 2) {
    // check for underflow
    if(found->second){
      found->second--;
    }
    bbprob->second.hits++;
    hits++;
  // if the branch is taken 'actual' and predicted to be strog or weak NOT TAKEN
  } else if (!count && found->second <2) {
    misses++;
    bbprob->second.misses++;
    if(found->second < 3){
      found->second++;
    }
  }
  return;
}

#define CHECKS 1000
bool MCPredictionMissRate::runOnFunction(Function &F) {
  std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
  std::default_random_engine Generator;
  

  errs() << "===/ Scanning Function: " << F.getName() << "\n";

  const auto &Blocks = F.getBasicBlockList();

  int loop_count{};

  auto cur = &Blocks.front();
  BasicBlock *prev{};
  // loop until you reach the full checks
  while(loop_count < CHECKS) {
    
    auto rand = Distribution(Generator);

    // check if it's a terminating block
    if(auto Succs = successors(cur).empty()) {
    // If the function only has a single basic block, then simply return false. We don't care about it
      if(cur == &Blocks.front()) {
        return false;
        // else if current block isn't the first block, it's a regular terminating block. Increase the looop count and go back to the start of the function
      } else { 
        errs() << loop_count << "\n";
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
      errs() << start << " ... " << end << "\n";
      errs() <<  " rand =  " << rand << "\n";
      if(rand >= start && rand < end) {
        next = succ;
        errs() << "chose basic block : " << count << "\n";
        break;
      }
      count++;
      start = end;
    }

    saturating2Bit(cur, count);

    prev = const_cast<BasicBlock*>(cur);
    cur = next;

    // If the terminating basic block is reached, increment the loop_count
    //
  }

  // for(uint64_t i = 0; i < CHECKS; i++) {
  //
  //   //Check if the Block is a terminating block
  //   if(auto Succs = successors(cur).empty()) {
  //     //Terminating block of the function
  //     if(cur == &Blocks.front()){
  //       return false;
  //     }
  //     loop_count = 0;
  //     cur = &Blocks.front();
  //     // errs() << "No successors to this block\n";
  //   }
  //   // Gets Probability info for the Block
  //   const auto Prob = BranchProbabilityInfo();
  //   auto Start = 0.0f;
  //   auto next = cur;
  //   // Used to check if the branch is take or not
  //   // 0 = yes
  //   // 1 = no
  //   auto count = 0;
  //   // Get the current basic block's successors
  //   for(auto Succ: successors(cur)) {
  //     // Save the edge probability with the successors address in a map
  //     // This can be used for the first part of the equation
  //     // For each Successor block, compare random number with probability range to select an 'Actual' chosen Successor
  //     auto EdgeProbs = Prob.getEdgeProbability(cur, Succ); 
  //     float End;
  //     End = Start + static_cast<float>(EdgeProbs.getNumerator()) / (EdgeProbs.getDenominator());
  //     if(nums[i] >= Start && nums[i] < End) {
  //       next = Succ;
  //       break;
  //     }
  //     count++;
  //     Start = End;
  //   }
  //   saturating2Bit(cur, count);
  //
  //   // Once the prediction has been determined, update individual block mis-prediction rate table
  //
  //   cur = next;
  // }


  // for each block i
  //  for each block j
  //    mis_rate = probability of i being executed (0.5 or 1) * probability of j being executed * mis-prediction rate for i to j

  double miss_rate = 1.0f;
  // for(auto &i : blockProbs) {
  //   errs() << "Printing for each block\n";
  // }
  auto Prob = BranchProbabilityInfo();
  for(auto &i : blockProbs) {
    for(auto j : successors(i.first)) {
      auto edges = Prob.getEdgeProbability(i.first, j);
      auto p = edges.getNumerator() / edges.getDenominator();
      // The probability from the cfg info  
      //                                                    Pmispredicts
      miss_rate += (p                 * p *          ((i.second.misses) / (i.second.misses)+(i.second.hits)));
      errs() << "miss rate for block : " << static_cast<int>(i.second.misses) << " of " << static_cast<int>(i.second.misses + i.second.hits) << "\n";
    }
  }

  errs() << "misses: " << misses << "\n";
  errs() << "hits: " << hits << "\n";
  errs() << "Miss Rate (%): " << static_cast<int>((misses/ (misses + hits)) * 100) << "\n";


  errs() << "Miss Rate (%) (NEW): " << static_cast<int>(0.50 * (miss_rate)) << "\n";
  return false;
}

char MCPredictionMissRate::ID = 0;
static RegisterPass<MCPredictionMissRate> X("mc-branch-miss", "Monte-Carlo branch prediction miss rate simulation",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
