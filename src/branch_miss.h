#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#include <random> 
#include <unordered_map> 

using namespace llvm;

struct BBProb {
  BBProb(BasicBlock *BB, BasicBlock *Chosen) : m_BB(BB), m_Chosen(BB) {};

  BasicBlock *m_BB;
  BasicBlock *m_Chosen;
};

struct MCPredictionMissRate : public FunctionPass {
  static char ID;
  MCPredictionMissRate() : FunctionPass(ID) {}

  float saturating2bit(std::vector<BBProb> bs);
  void simulate(std::vector<BBProb>, std::vector<std::function<float(BBProb)>> f);

  bool runOnFunction(Function &F) override;

  
  std::vector<BBProb> Blocks;
}; // end of struct Hello
