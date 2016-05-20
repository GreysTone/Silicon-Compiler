//////////////////////////////////////////////////////////////////////////////
//
// global.h
//
// Global structure definition
//
// Project          : Silicon_Compiler
// Author           : Danyang Song (Arthur) Handle: GreysTone
// Contact          : arthur_song@sfu.ca
// Student ID       : 301295765, dsa65
// Instructor       : Anoop Sarkar
//
// Created by GreysTone on 2016-05-19.
// Copyright (c) 2016 GreysTone. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////

#ifndef SILICON_COMPILER_GLOBAL_H
#define SILICON_COMPILER_GLOBAL_H

#include <cstdint>

namespace GT_SILICON_COMPILER {
enum class GT_LEXICAL_TOKEN : std::int8_t {
  T_IDENTIFIER  = 0,
  T_SEMICOLON   = ';',
  T_LPAREN      = '(',
  T_RPAREN      = ')',
  T_IF,
  T_WHILE,
  T_FOR,
  T_RETURN,
  T_UNKNOWN
};
} // namespace GT_SILICON_COMPILER

#endif //SILICON_COMPILER_GLOBAL_H
