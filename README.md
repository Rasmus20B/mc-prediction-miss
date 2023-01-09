# mc-prediction-miss
Monte-Carlo branch prediction simulation to statically determine number of branch misses in llvm IR code. 

## Usage
To build and invoke on an llvm file (using the matrix.ll file found in the tests directory as an example), use the following commands:
```
mkdir build && cd build && cmake .. && make
mpirun opt -load lib/libMCBranchPredictionMiss.so -disable-output -enable-new-pm=0 ../test/matrix.ll -mc-branch-miss
```
