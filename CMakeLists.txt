
cmake_minimum_required(VERSION 3.5)
# support C++14 features used by LLVM 10.0.0
# set(CMAKE_CXX_STANDARD 20)
SET(CMAKE_CXX_FLAGS "-Wall -fno-rtti -std=c++20")

project(mc-branch-miss)

# find_package(LLVM REQUIRED CONFIG)
# add_definitions(${LLVM_DEFINITIONS})
# include_directories(${LLVM_INCLUDE_DIRS})
# link_directories(${LLVM_LIBRARY_DIRS})
set (search_paths
    ${PATH_TO_LLVM}
    ${PATH_TO_LLVM}/lib/cmake
    ${PATH_TO_LLVM}/lib/cmake/llvm
    ${PATH_TO_LLVM}/share/llvm/cmake/
  )


find_package(LLVM REQUIRED CONFIG PATHS ${search_paths} NO_DEFAULT_PATH)
include(LLVM-Config)
include(HandleLLVMOptions)
include(AddLLVM)
add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

find_package(MPI REQUIRED)
include_directories(SYSTEM ${MPI_INCLUDE_PATH})


set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib")

add_subdirectory(src)
