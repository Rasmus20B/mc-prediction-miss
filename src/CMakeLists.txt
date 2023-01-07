add_library(MCBranchPredictionMiss
  MODULE
  branch_miss.cc
)
target_link_libraries(MCBranchPredictionMiss PUBLIC MPI::MPI_CXX)
