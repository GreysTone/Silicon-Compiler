//////////////////////////////////////////////////////////////////////////////
//
// main.cc
//
// Silicon Compiler
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

#include "lexical_analyser.h"

//
// Function: main
// ---------------------------
//
//   Main entrance
//
//   Parameters:
//       argc:  the number of parameters from CLI
//       argv:  the pointer of parameters from CLI
//
int main (int argc, char **argv) {
  LexicalAnalyser analyser;
  analyser.analyse();

  return 0;
}