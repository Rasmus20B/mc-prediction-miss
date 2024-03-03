add_library(MCBranchPredictionMiss
  SHARED
  branch_miss.cc
)

target_link_libraries(MCBranchPredictionMiss PUBLIC 
  "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>" MPI::MPI_CXX)
