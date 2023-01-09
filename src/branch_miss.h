#pragma once

#include <algorithm> 

#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/CFG.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#include "predictor.h"
#include "config.h"


using namespace llvm;
// a given probability struct:
// keeps track of the successors of a given basic block
// keeps track of how many times it hits or misses each of those blocks
// is related to a basic block
struct ps{
  // the number of branch prediction hits
  uint64_t hits{};
  // the number of branch prediction misses
  uint64_t misses{};
  // the number of times the branch was actually run
  uint64_t n_executes{};
  // the number of times this branch was inspected
  uint64_t n_arrives{};
  // Probability according to CFG of next branch being executed
  double prob_cur{};
  // Probability of previous current branch having been executed
  double prob_prev{};
};

enum BlockType {
  NORM,
  TERM,
  EMPTY
};

// Keep track of how many times a basic block has been run
// used in final calculation to compare against how many times the program itself has been run
inline std::unordered_map<const BasicBlock*, int> runs;

struct MCPredictionMissRate : public FunctionPass {
  static char ID;
  MCPredictionMissRate() : FunctionPass(ID) {}
  bool runOnFunction(Function &F) override;
  bool doInitialization(Module &M) override;
  bool doFinalization(Module &M) override;

  bool saturating2Bit(const BasicBlock* cur,  uint32_t count) noexcept;
  bool correlation(const BasicBlock* cur, uint32_t count) noexcept;

  float getBlockMissRate(const BasicBlock& bb, const std::unordered_map<int, ps> pb) noexcept;
  std::tuple<const BasicBlock*, uint32_t> getActualSuccessor(const BasicBlock& bb, const BranchProbabilityInfo& bp) noexcept;
  inline BlockType isTerminatingBlock(const BasicBlock& bb, const BasicBlock& front) noexcept;

  double hits;
  double misses;
}; // end of struct Hello
