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

inline std::unordered_map<const BasicBlock*, uint32_t> BHT;

struct MCPredictionMissRate : public FunctionPass {
  static char ID;
  MCPredictionMissRate() : FunctionPass(ID) {}
  bool runOnFunction(Function &F) override;

  void saturating2Bit(const BasicBlock* cur,  uint32_t count) noexcept;
  void biMode(const BasicBlock* cur, uint32_t) noexcept;

  double hits;
  double misses;

}; // end of struct Hello
