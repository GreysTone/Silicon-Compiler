//////////////////////////////////////////////////////////////////////////////
//
// lexical_analyser.h
//
// Header of Class Lexical Analyser
//
// Project          : Silicon_Compiler
// Author           : Danyang Song (Arthur) Handle: GreysTone
// Contact          : arthur_song@sfu.ca
// Student ID       : 301295765, dsa65
// Instructor       : Anoop Sarkar
//
// Created by GreysTone on 2016-05-18.
// Copyright (c) 2016 GreysTone. All rights reserved.
//
//////////////////////////////////////////////////////////////////////////////

#ifndef SILICON_COMPILER_LEXICAL_ANALYSER_H
#define SILICON_COMPILER_LEXICAL_ANALYSER_H

#include "global.h"
#include <map>
#include <string>

//
// Class: Lexical Analyser
// ---------------------------
//
//   Lexical Analyser
//
//   Usage:
//       LexicalAnalyser analyser;
//       analyser.analyse();
//

class LexicalAnalyser {
  std::map<GT_SILICON_COMPILER::GT_LEXICAL_TOKEN, std::string> tokenString;
  std::int32_t currentLine;
  std::int32_t currentChar;

public:
  LexicalAnalyser();

  void analyse();
};

#endif //SILICON_COMPILER_LEXICAL_ANALYSER_H
