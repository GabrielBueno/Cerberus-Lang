cmake_minimum_required(VERSION 3.15)

project(Cerberus)

set(CMAKE_C_COMPILER "gcc")
set(CMAKE_CXX_COMPILER "g++")

set(CMAKE_CXX_FLAGS "-Wall -Wextra")

file(GLOB_RECURSE SRCS "src/*.h" "src/*.cpp")

add_executable(Cerberus ${SRCS})


