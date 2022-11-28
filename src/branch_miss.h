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

// Used by 2-bit saturating counter
inline std::unordered_map<const BasicBlock*, uint32_t> satBHT;

// Used by Two-level adaptive correlation-based scheme
inline std::unordered_map<const BasicBlock*, uint8_t> corBHT;
inline std::unordered_map<uint8_t, uint32_t> corBPT;

struct MCPredictionMissRate : public FunctionPass {
  static char ID;
  MCPredictionMissRate() : FunctionPass(ID) {}
  bool runOnFunction(Function &F) override;

  void saturating2Bit(const BasicBlock* cur,  uint32_t count) noexcept;
  void correlation(const BasicBlock* cur, uint32_t count) noexcept;

  double hits;
  double misses;

}; // end of struct Hello
