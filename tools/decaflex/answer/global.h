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
// Last Modified on 2016-05-26 by Danyang Song (Arthur), arthur_song@sfu.ca
// Modified         : Enumerate necessary tokens
//
//////////////////////////////////////////////////////////////////////////////

#ifndef SILICON_COMPILER_GLOBAL_H
#define SILICON_COMPILER_GLOBAL_H

#include <cstdint>

namespace GT_SILICON_COMPILER {
enum class GT_LEXICAL_TOKEN : std::int32_t {
  // Delimiter
  T_COMMA          = ',',
  T_LPAREN         = '(',
  T_LCB            = '{',
  T_LSB            = '[',
  T_RCB            = '}',
  T_RPAREN         = ')',
  T_RSB            = ']',
  T_SEMICOLON      = ';',

  // Operator
  T_AND            = 0xA201, // &&
  T_ASSIGN         = '=',
  T_DIV            = '/',
  T_DOT            = '.',
  T_EQ             = 0xA202, // ==
  T_GEQ            = 0xA203, // >=
  T_GT             = '>',
  T_LEFTSHIFT      = 0xA204, // <<
  T_LEQ            = 0xA205, // <=
  T_LT             = '<',
  T_MINUS          = '-',
  T_MOD            = '%',
  T_MULT           = '*',
  T_NEQ            = 0xA206, // !=
  T_NOT            = '!',
  T_OR             = 0xA207, // ||
  T_PLUS           = '+',
  T_RIGHTSHIFT     = 0xA208, // >>

  // Preserved Keyword
  T_BOOLTYPE       = 0xA209, // bool
  T_BREAK                  , // break
  T_CONTINUE               , // continue
  T_ELSE                   , // else
  T_EXTERN                 , // extern
  T_FALSE                  , // false
  T_FOR                    , // for
  T_FUNC                   , // func
  T_IF                     , // if
  T_INTTYPE                , // int
  T_NULL                   , // null
  T_PACKAGE                , // package
  T_RETURN                 , // return
  T_STRINGTYPE             , // string
  T_TRUE                   , // true
  T_VAR                    , // var
  T_VOID                   , // void
  T_WHILE                  , // while

  // Literal
  T_CHARCONSTANT           , // char_lit (see section on Character literals)
  T_INTCONSTANT            , // int_lit (see section on Integer literals)
  T_STRINGCONSTANT         , // string_lit (see section on String literals)

  // Other
  T_IDENTIFIER             , // identifier (see section on Identifiers)
  T_WHITESPACE             , // whitespace (see section on Whitespace)
  T_COMMENT                , // comment
	T_ERR_UNKNOWN						 , // err_unknown
	T_ERR_UNKNOWN_ESCAPE		 , // err_unknown_escape_sequence
	T_ERR_LITCON_UNWIDTH		 , // err_literal_constant_unexpected_width
  T_UNKNOWN        = 0xA200
};

enum class GT_LEXICAL_ERROR : std::int32_t {
	ERR_UNKNOWN						 , // err_unknown
	ERR_UNKNOWN_ESCAPE		 , // err_unknown_escape_sequence
	ERR_LITCON_UNWIDTH		 , // err_literal_constant_unexpected_width
};
} // namespace GT_SILICON_COMPILER

#endif //SILICON_COMPILER_GLOBAL_H
