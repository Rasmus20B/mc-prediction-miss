#include "branch_miss.h"

using namespace llvm;

  bool MCPredictionMissRate::runOnFunction(Function &F) {
    std::uniform_real_distribution<float>  Distribution(0.0, 1.0);
    std::default_random_engine Generator;

    std::unordered_map<BasicBlock*, uint16_t> Suc_ids;
    float num;

      for(auto &Block : F.getBasicBlockList()) {
        errs() << "=======================\n";
        errs() << "Scanning BB : " << &Block << "\n";
        num = Distribution(Generator);
        auto Prob = BranchProbabilityInfo();
        auto Start = 0.0f;
        for(auto Suc : successors(&Block)) {
          auto EdgeProbs = Prob.getEdgeProbability(&Block, Suc);
          float End;
          End = Start + static_cast<float>(EdgeProbs.getNumerator()) / (EdgeProbs.getDenominator());
          errs() << "checking Successor : " << *(&Suc) << "\n";
          if(num >= Start && num <= End) {
            Blocks.push_back(BBProb(static_cast<BasicBlock*>(&Block), static_cast<BasicBlock *>(Suc)));
            errs() << &Block << " : " << *(&Suc) << "\n";
            break;
          }
      }
    }
    return false;
  }
  
char MCPredictionMissRate::ID = 0;
static RegisterPass<MCPredictionMissRate> X("mc-branch-miss", "Monte-Carlo branch prediction miss rate simulation",
                             false /* Only looks at CFG */,
                             false /* Analysis Pass */);
