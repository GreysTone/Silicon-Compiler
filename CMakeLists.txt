cmake_minimum_required(VERSION 3.5)
project(Silicon_Compiler)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -Wall -Wno-deprecated-register -ll")

# header files
include_directories(include)

# find bison/flex
#find_package(BISON)
find_package(FLEX)

set(SOURCE_FILES
        src/main.cc
        include/lexical_analyser.h
        include/global.h)

FLEX_TARGET(LexicalAnalyser src/lexical_analyser.lex  ${CMAKE_CURRENT_BINARY_DIR}/lexical_analyser.cc)
#ADD_FLEX_BISON_DEPENDENCY(LexicalAnalyser )


add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${FLEX_LexicalAnalyser_OUTPUTS})