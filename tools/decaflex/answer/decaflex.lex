/*////////////////////////////////////////////////////////////////////////////
//
// decaflex.lex
//
// Silicon Compiler
//
// Project          : Silicon_Compiler
// Author           : Danyang Song (Arthur) Handle: GreysTone
// Contact          : arthur_song@sfu.ca
// Student ID       : 301295765, dsa65
// Instructor       : Anoop Sarkar
//
// Created by GreysTone on 2016-05-26.
// Copyright (c) 2016 GreysTone. All rights reserved.
// Last Modified on 2016-05-27 by Danyang Song (Arthur), arthur_song@sfu.ca
// Modified         : Added preserved keywords, modified comments style to support compile .lex
//
////////////////////////////////////////////////////////////////////////////*/

%{

#include "global.h"
#include <map>
#include <string>
#include <iostream>
#include <cstdlib>

using namespace std;
using namespace GT_SILICON_COMPILER;

%}

/* RegExp definitions (LEX) */
digit       [0-9]
letter      [a-zA-Z\_]
hexDigit    [a-fA-F{digit}]
allChar     [\x7-\xd\x20-\x7e]
normChar    [\x7-\xd\x20-\x5b\x5d-\x7e]
noNlChar    [\x7-\x9\xb-\xd\x20-\x7e]
noSglChar   [\x7-\xd\x20-\x26\x28-\x5b\x5d-\x7e]
noDblChar   [\x7-\x9\xb-\xd\x20\x21\x23-\x5b\x5d-\x7e]

comment     \/\/{noNlChar}*\n
bell        \a
backspace   \b
newline     \n
whitespace  [\n\r\t\v\f ]+
identifier  {letter}({letter}|{digit})*

dec_lit     {digit}+
hex_lit     0[xX]{hexDigit}+
int_lit     {dec_lit}|{hex_lit}
escaped     \\[nrtvfab\\\'\"]
char_lit    '({noSglChar}|{escaped})'
string_lit  \"({noDblChar}|{escaped})*\"

/* Pattern definitions for all tokens (LEX) */
%%
{string_lit}                    { return (std::int32_t)GT_LEXICAL_TOKEN::T_STRINGCONSTANT; }
{char_lit}                      { return (std::int32_t)GT_LEXICAL_TOKEN::T_CHARCONSTANT; }
{int_lit}                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_INTCONSTANT; }

,                               { return (std::int32_t)GT_LEXICAL_TOKEN::T_COMMA; }
\{                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_LCB; }
\(                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_LPAREN; }
\[                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_LSB; }
\}                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_RCB; }
\)                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_RPAREN; }
\]                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_RSB; }
\;                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_SEMICOLON; }

=                               { return (std::int32_t)GT_LEXICAL_TOKEN::T_ASSIGN; }
\/                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_DIV; }
\.                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_DOT; }
\>                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_GT; }
\<                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_LT; }
-                               { return (std::int32_t)GT_LEXICAL_TOKEN::T_MINUS; }
%                               { return (std::int32_t)GT_LEXICAL_TOKEN::T_MOD; }
\*                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_MULT; }
!                               { return (std::int32_t)GT_LEXICAL_TOKEN::T_NOT; }
\+                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_PLUS; }
&&                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_AND; }
==                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_EQ; }
\>=                             { return (std::int32_t)GT_LEXICAL_TOKEN::T_GEQ; }
\<\<                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_LEFTSHIFT; }
\<=                             { return (std::int32_t)GT_LEXICAL_TOKEN::T_LEQ; }
!=                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_NEQ; }
\|\|                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_OR; }
\>\>                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_RIGHTSHIFT; }

bool                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_BOOLTYPE; }
break                           { return (std::int32_t)GT_LEXICAL_TOKEN::T_BREAK; }
continue                        { return (std::int32_t)GT_LEXICAL_TOKEN::T_CONTINUE; }
else                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_ELSE; }
extern                          { return (std::int32_t)GT_LEXICAL_TOKEN::T_EXTERN; }
false                           { return (std::int32_t)GT_LEXICAL_TOKEN::T_FALSE; }
for                             { return (std::int32_t)GT_LEXICAL_TOKEN::T_FOR; }
func                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_FUNC; }
if                              { return (std::int32_t)GT_LEXICAL_TOKEN::T_IF; }
int                             { return (std::int32_t)GT_LEXICAL_TOKEN::T_INTTYPE; }
null                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_NULL; }
package                         { return (std::int32_t)GT_LEXICAL_TOKEN::T_PACKAGE; }
return                          { return (std::int32_t)GT_LEXICAL_TOKEN::T_RETURN; }
string                          { return (std::int32_t)GT_LEXICAL_TOKEN::T_STRINGTYPE; }
true                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_TRUE; }
var                             { return (std::int32_t)GT_LEXICAL_TOKEN::T_VAR; }
void                            { return (std::int32_t)GT_LEXICAL_TOKEN::T_VOID; }
while                           { return (std::int32_t)GT_LEXICAL_TOKEN::T_WHILE; }

{identifier}                    { return (std::int32_t)GT_LEXICAL_TOKEN::T_IDENTIFIER; }
{whitespace}                    { return (std::int32_t)GT_LEXICAL_TOKEN::T_WHITESPACE; }
{comment}                       { return (std::int32_t)GT_LEXICAL_TOKEN::T_COMMENT; }
.                               { return (std::int32_t)GT_LEXICAL_TOKEN::T_UNKNOWN; }
%%

/* \n                         { return 10; } */
/* adds description string for output */
map<GT_LEXICAL_TOKEN, string> tokenString;
/*tokenString.insert(pair<GT_LEXICAL_TOKEN,string>(GT_LEXICAL_TOKEN::T_BOOLTYPE, "T_BOOLTYPE"));*/

/*
// Function: init
// ---------------------------
//
//   Initialise output string for each available token
//
//   Parameters:
//       null
*/
void
init () {
  /* Delimiter */
  tokenString[GT_LEXICAL_TOKEN::T_COMMA]          = "T_COMMA";
  tokenString[GT_LEXICAL_TOKEN::T_LCB]            = "T_LCB";
  tokenString[GT_LEXICAL_TOKEN::T_LPAREN]         = "T_LPAREN";
  tokenString[GT_LEXICAL_TOKEN::T_LSB]            = "T_LSB";
  tokenString[GT_LEXICAL_TOKEN::T_RCB]            = "T_RCB";
  tokenString[GT_LEXICAL_TOKEN::T_RPAREN]         = "T_RPAREN";
  tokenString[GT_LEXICAL_TOKEN::T_RSB]            = "T_RSB";
  tokenString[GT_LEXICAL_TOKEN::T_SEMICOLON]      = "T_SEMICOLON";

  /* Operator */
  tokenString[GT_LEXICAL_TOKEN::T_ASSIGN]         = "T_ASSIGN";
  tokenString[GT_LEXICAL_TOKEN::T_DIV]            = "T_DIV";
  tokenString[GT_LEXICAL_TOKEN::T_DOT]            = "T_DOT";
  tokenString[GT_LEXICAL_TOKEN::T_GT]             = "T_GT";
  tokenString[GT_LEXICAL_TOKEN::T_LT]             = "T_LT";
  tokenString[GT_LEXICAL_TOKEN::T_MINUS]          = "T_MINUS";
  tokenString[GT_LEXICAL_TOKEN::T_MOD]            = "T_MOD";
  tokenString[GT_LEXICAL_TOKEN::T_MULT]           = "T_MULT";
  tokenString[GT_LEXICAL_TOKEN::T_NOT]            = "T_NOT";
  tokenString[GT_LEXICAL_TOKEN::T_PLUS]           = "T_PLUS";
  tokenString[GT_LEXICAL_TOKEN::T_AND]            = "T_AND";
  tokenString[GT_LEXICAL_TOKEN::T_EQ]             = "T_EQ";
  tokenString[GT_LEXICAL_TOKEN::T_GEQ]            = "T_GEQ";
  tokenString[GT_LEXICAL_TOKEN::T_LEFTSHIFT]      = "T_LEFTSHIFT";
  tokenString[GT_LEXICAL_TOKEN::T_LEQ]            = "T_LEQ";
  tokenString[GT_LEXICAL_TOKEN::T_NEQ]            = "T_NEQ";
  tokenString[GT_LEXICAL_TOKEN::T_OR]             = "T_OR";
  tokenString[GT_LEXICAL_TOKEN::T_RIGHTSHIFT]     = "T_RIGHTSHIFT";

  /* Preserved Keyword */
  tokenString[GT_LEXICAL_TOKEN::T_BOOLTYPE]       = "T_BOOLTYPE";
  tokenString[GT_LEXICAL_TOKEN::T_BREAK]          = "T_BREAK";
  tokenString[GT_LEXICAL_TOKEN::T_CONTINUE]       = "T_CONTINUE";
  tokenString[GT_LEXICAL_TOKEN::T_ELSE]           = "T_ELSE";
  tokenString[GT_LEXICAL_TOKEN::T_EXTERN]         = "T_EXTERN";
  tokenString[GT_LEXICAL_TOKEN::T_FALSE]          = "T_FALSE";
  tokenString[GT_LEXICAL_TOKEN::T_FOR]            = "T_FOR";
  tokenString[GT_LEXICAL_TOKEN::T_FUNC]           = "T_FUNC";
  tokenString[GT_LEXICAL_TOKEN::T_IF]             = "T_IF";
  tokenString[GT_LEXICAL_TOKEN::T_INTTYPE]        = "T_INTTYPE";
  tokenString[GT_LEXICAL_TOKEN::T_NULL]           = "T_NULL";
  tokenString[GT_LEXICAL_TOKEN::T_PACKAGE]        = "T_PACKAGE";
  tokenString[GT_LEXICAL_TOKEN::T_RETURN]         = "T_RETURN";
  tokenString[GT_LEXICAL_TOKEN::T_STRINGTYPE]     = "T_STRINGTYPE";
  tokenString[GT_LEXICAL_TOKEN::T_TRUE]           = "T_TRUE";
  tokenString[GT_LEXICAL_TOKEN::T_VAR]            = "T_VAR";
  tokenString[GT_LEXICAL_TOKEN::T_VOID]           = "T_VOID";
  tokenString[GT_LEXICAL_TOKEN::T_WHILE]          = "T_WHILE";

  /* Literal */
  tokenString[GT_LEXICAL_TOKEN::T_CHARCONSTANT]   = "T_CHARCONSTANT";
  tokenString[GT_LEXICAL_TOKEN::T_INTCONSTANT]    = "T_INTCONSTANT";
  tokenString[GT_LEXICAL_TOKEN::T_STRINGCONSTANT] = "T_STRINGCONSTANT";

  /* Other */
  tokenString[GT_LEXICAL_TOKEN::T_IDENTIFIER]     = "T_ID";
  tokenString[GT_LEXICAL_TOKEN::T_WHITESPACE]     = "T_WHITESPACE";
  tokenString[GT_LEXICAL_TOKEN::T_COMMENT]        = "T_COMMENT";
  tokenString[GT_LEXICAL_TOKEN::T_UNKNOWN]        = "T_UNKNOWN";
}

/*
// Function: main
// ---------------------------
//
//   Main entrance
//
//   Parameters:
//       argc:  the number of parameters from CLI
//       argv:  the pointer of parameters from CLI
*/
int
main (int argc, char **argv) {
  init();

  GT_LEXICAL_TOKEN token;
  /*string lexeme;*/
  /*lexeme.assign(yytext);*/

  while ((std::int32_t)(token = (GT_LEXICAL_TOKEN)yylex())) {
    if (token != GT_LEXICAL_TOKEN::T_UNKNOWN) {
      /* handle invisiable character */
      if (token == GT_LEXICAL_TOKEN::T_WHITESPACE || token == GT_LEXICAL_TOKEN::T_COMMENT) {
        cout << tokenString[token] << " ";
        for (int i = 0; i < strlen(yytext); ++i) {
          switch (yytext[i]) {
            case '\n': cout << "\\n"; break;
            default:
              cout << yytext[i];
          }
        }
        cout << endl;
      } else {
        cout << tokenString[token] << " " << yytext << endl;
      }
    } else {
      cerr << "Error: unexpected character in input" << endl;
      exit(EXIT_FAILURE);
    }
  }

  exit(EXIT_SUCCESS);
}
