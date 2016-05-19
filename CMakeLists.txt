cmake_minimum_required(VERSION 3.5)
project(Silicon_Compiler)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall")

# header files
include_directories(include)

set(SOURCE_FILES
        src/main.cc
        include/lexical_analyser.h
        src/lexical_analyser.cc
        include/global.h)


add_executable(${PROJECT_NAME} ${SOURCE_FILES})