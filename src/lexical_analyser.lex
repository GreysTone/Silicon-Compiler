/*////////////////////////////////////////////////////////////////////////////
//
// lexical_analyser.lex
//
// Implementation of Class Lexical Analyser (un-compile)
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
////////////////////////////////////////////////////////////////////////////*/

%{
#include "lexical_analyser.h"
#include <iostream>
#include <cstdlib>

using namespace std;
using namespace GT_SILICON_COMPILER;
%}

/* RegExp definitions (LEX) */
num [0-9]+

/* Pattern definitions for all tokens (LEX) */
%%
bool                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_BOOLTYPE; }
break                      { return (std::int32_t)GT_LEXICAL_TOKEN::T_BREAK; }
continue                   { return (std::int32_t)GT_LEXICAL_TOKEN::T_CONTINUE; }
else                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_ELSE; }
extern                     { return (std::int32_t)GT_LEXICAL_TOKEN::T_EXTERN; }
false                      { return (std::int32_t)GT_LEXICAL_TOKEN::T_FALSE; }
for                        { return (std::int32_t)GT_LEXICAL_TOKEN::T_FOR; }
func                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_FUNC; }
if                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_IF; }
int                        { return (std::int32_t)GT_LEXICAL_TOKEN::T_INTTYPE; }
null                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_NULL; }
package                    { return (std::int32_t)GT_LEXICAL_TOKEN::T_PACKAGE; }
return                     { return (std::int32_t)GT_LEXICAL_TOKEN::T_RETURN; }
string                     { return (std::int32_t)GT_LEXICAL_TOKEN::T_STRINGTYPE; }
true                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_TRUE; }
var                        { return (std::int32_t)GT_LEXICAL_TOKEN::T_VAR; }
void                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_VOID; }
while                      { return (std::int32_t)GT_LEXICAL_TOKEN::T_WHILE; }
\{                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_LCB; }
\}                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_RCB; }
\(                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_LPAREN; }
\)                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_RPAREN; }
\;                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_SEMICOLON; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { return (std::int32_t)GT_LEXICAL_TOKEN::T_IDENTIFIER; }
[\t\r\a\v\b ]+             { return (std::int32_t)GT_LEXICAL_TOKEN::T_WHITESPACE; }
\n                         { return 10; }
.                          { cerr << "Error: unexpected character in input" << endl; return (std::int32_t)GT_LEXICAL_TOKEN::T_UNKNOWN; }
%%

LexicalAnalyser::LexicalAnalyser() {

}

void LexicalAnalyser::analyse() {
  std::int32_t token;
  string lexeme;

  while ((token = yylex())) {
    if (token != (std::int32_t)0xA200) {
      lexeme.assign(yytext);
	  switch(token) {
		case (std::int32_t)GT_LEXICAL_TOKEN::T_FUNC:    cout << "T_FUNC " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_INTTYPE: cout << "T_INT " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_PACKAGE: cout << "T_PACKAGE " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_LCB: cout << "T_LCB " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_RCB: cout << "T_RCB " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_LPAREN: cout << "T_LPAREN " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_RPAREN: cout << "T_RPAREN " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_IDENTIFIER: cout << "T_ID " << lexeme << endl; break;
		case (std::int32_t)GT_LEXICAL_TOKEN::T_WHITESPACE: cout << "T_WHITESPACE " << lexeme << endl; break;
		case (std::int32_t)10: cout << "T_WHITESPACE \\n" << endl; break;
		default: exit(EXIT_FAILURE);
	  }
    } else {
      exit(EXIT_FAILURE);
    }
  }
  exit(EXIT_SUCCESS);
}