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

inline std::unordered_map<const BasicBlock*, int> BHT;

struct MCPredictionMissRate : public FunctionPass {
  static char ID;
  MCPredictionMissRate() : FunctionPass(ID) {}

  bool runOnFunction(Function &F) override;

  double hits;
  double misses;

}; // end of struct Hello
