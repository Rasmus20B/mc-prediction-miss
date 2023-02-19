#pragma once

#include "llvm/IR/BasicBlock.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;

class Predictor {
  public:
    virtual auto predict(const BasicBlock* cur, uint32_t count) noexcept -> bool { return true; }
};

class Saturating2Bit : public Predictor {
  public:
    auto predict(const BasicBlock* cur, uint32_t count) noexcept -> bool override {  
      auto found = bht.find(cur);
      if((found == bht.end())) { bht.insert(std::pair<const BasicBlock*, int>(cur, 4)); } 
      found = bht.find(cur); // If the branch is taken 'actual' and predicted to be strong or weak TAKEN 
      if(!count && found->second > 1) {
        if(found->second < 3){
          found->second++;
        }
        return true;
      // if the branch is not taken 'actual' and predicted to be strong or weak TAKEN
      } else if(count == 1 && (found->second > 1)) {
        if(found->second){
          found->second--;
        }
        return false;
      // if the branch is not taken 'actual' and predicted to be strong or weak NOT TAKEN
      } else if (count == 1 && found->second < 2) {
        // check for underflow
        if(found->second){
          found->second--;
        }
        return true;
      // if the branch is taken 'actual' and predicted to be strog or weak NOT TAKEN
      } else if (!count && found->second <2) {
        if(found->second < 3){
          found->second++;
        }
        return false;
      }
      return true;
    }

  private:
    std::unordered_map<const BasicBlock*, uint32_t> bht{};
};

class Correlation : public Predictor {
  public:
    auto predict(const BasicBlock* cur, uint32_t count) noexcept -> bool override {

    // use the address to index the history table
    auto history = corBHT.find(cur);
    if((history == corBHT.end())) {
      // if we can't find a hitory for a given block, then add one
      corBHT.insert(std::pair<const BasicBlock*, int>(cur, 0b11111111));
    }
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
      //update the saturation counter
      if(res->second < 3)
        res->second++;
      //update the history value
      // shift the history to the left, and add the outcome (1, 0) to the least significant bit
      history->second = (history->second << 1) | 0b00000001;
      return true;
    }
    // if branch is actually taken but not predicted to be taken
    if(!count && res->second < 2) {
      if(res->second < 3)
        res->second++;
      history->second = (history->second << 1) | 0b00000001;
      return false;
    }
    // if branch is not taken but predicted to be taken
    if(count && res->second > 1) {
      if(res->second > 0)
        res->second--;
      history->second = (history->second << 1) ;
      return false;
    }
    // if branch is not taken and is not predicted to be taken
    if(count && res->second < 2) {
      if(res->second > 0)
        res->second--;
      history->second = (history->second) ;
      return true;
    } 

    return true;

  }
  private:
  std::unordered_map<const BasicBlock*, uint8_t> corBHT;
  std::unordered_map<uint8_t, uint32_t> corBPT;
};

