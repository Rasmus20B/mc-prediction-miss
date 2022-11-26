#include "branch_miss.h"

using namespace llvm;
  
float MCPredictionMissRate::saturating2bit(std::vector<BBProb> bs) {

  return 0;
}

void MCPredictionMissRate::simulate(std::vector<BBProb>, std::vector<std::function<float(BBProb)>> f) {

  return;
}

bool MCPredictionMissRate::runOnFunction(Function &F) {
  std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
  std::default_random_engine Generator;

  std::unordered_map<BasicBlock*, uint16_t> Suc_ids;
  float num[1000];
  int num_count = {0};

  for(auto &i : num) {
    i = Distribution(Generator);
  }

  // errs() << "===/ Scanning Function: " << F.getName() << "\n";

  for(auto &Block : F.getBasicBlockList()) {
    // errs() << "=======================\n";
    // errs() << "Scanning BB : " << &Block << "\n";
    auto Prob = BranchProbabilityInfo();
    auto Start = 0.0f;
    // errs() << "num: " << num[num_count] << "\n";
    for(auto Suc : successors(&Block)) {
      auto EdgeProbs = Prob.getEdgeProbability(&Block, Suc);
      float End;
      End = Start + static_cast<float>(EdgeProbs.getNumerator()) / (EdgeProbs.getDenominator());
      // errs() << "checking Successor : " << *(&Suc) << " with range [" << Start << "," << End << "]\n";
      if(num[num_count] >= Start && num[num_count] < End) {
        Blocks.push_back(BBProb(static_cast<BasicBlock*>(&Block), static_cast<BasicBlock *>(Suc)));
        // errs() << &Block << " chose: " << *(&Suc) << "\n";
        break;
      }
      Start = End;
    }
    num_count++;
  }

  saturating2bit(Blocks);

  return false;
}

char MCPredictionMissRate::ID = 0;
static RegisterPass<MCPredictionMissRate> X("mc-branch-miss", "Monte-Carlo branch prediction miss rate simulation",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
