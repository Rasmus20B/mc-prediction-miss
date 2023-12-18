#pragma once 

#include "predictor.h" 

// Number of test runs to be given to each MPI Job
constexpr auto tests = 200000;

// Either Saturating2Bit or Correlation
using Circuit = Saturating2Bit;
