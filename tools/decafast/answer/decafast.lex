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
#include "decafast-defs.h"
#include "decafast.tab.h"
#include <map>
#include <string>
#include <iostream>
#include <cstdlib>

using namespace std;

std::int32_t currentLine=1; /* offset for the first line */
std::int32_t currentChar=1; /* offset for the next token */

void
shiftCursor(bool special = false) {
    currentChar += strlen(yytext);
    if(special) {
        for (int i = 0; i < strlen(yytext); ++i) {
            switch (yytext[i]) {
                case '\n': {
                    ++currentLine;
                    currentChar = strlen(yytext) - i;
                    break;
                }
            }
        }
    }
}

%}

/* RegExp definitions (LEX) */
digit       [0-9]
letter      [a-zA-Z\_]
hexDigit    [a-fA-F0-9]
allChar     [\x7-\xd\x20-\x7e]
normChar    [\x7-\xd\x20-\x5b\x5d-\x7e]
noNlChar    [\x7-\x9\xb-\xd\x20-\x7e]
noSglChar   [\x7-\x9\xb-\xd\x20-\x26\x28-\x5b\x5d-\x7e]
noDblChar   [\x7-\x9\xb-\xd\x20\x21\x23-\x5b\x5d-\x7e]

comment     \/\/{noNlChar}*\n
bell        \a
backspace   \b
newline     \n
whitespace  [\n\r\t\v\f ]+
identifier  {letter}({letter}|{digit})*

dec_lit     {digit}+
hex_lit     0[xX]{hexDigit}+
int_lit     ({hex_lit}|{dec_lit})
escaped     \\[nrtvfab\\'\"]
unescap		[\x7-\x9\xb-\xd\x20\x21\x23-\x26\x28-\x5b\x5d-\x60\x63-\x65\x67-\x6d\x6f-\x71\x73\x75\x77-\x7e]
char_lit    '({noSglChar}|{escaped})'
string_lit  \"({noDblChar}|{escaped})*\"
char_err_width ''
char_err_mwidth '{noSglChar}{noSglChar}+'
char_err_iwidth '
strs_err_iwidth \"({noDblChar}|{escaped})*\n
char_err_escape '\\{unescap}
strs_err_escape \"({noDblChar}|{escaped})*\\{unescap}

/* Pattern definitions for all tokens (LEX) */
%%
{string_lit}     { shiftCursor(); yylval.sval = new std::string(yytext); return T_STRINGCONSTANT; }
{char_lit}       { shiftCursor(); yylval.sval = new std::string(yytext); return T_CHARCONSTANT; }
{int_lit}        { shiftCursor(); yylval.sval = new std::string(yytext); return T_INTCONSTANT; }

,                { shiftCursor(); return T_COMMA; }
\{               { shiftCursor(); return T_LCB; }
\(               { shiftCursor(); return T_LPAREN; }
\[               { shiftCursor(); return T_LSB; }
\}               { shiftCursor(); return T_RCB; }
\)               { shiftCursor(); return T_RPAREN; }
\]               { shiftCursor(); return T_RSB; }
\;               { shiftCursor(); return T_SEMICOLON; }

=                { shiftCursor(); return T_ASSIGN; }
\/               { shiftCursor(); return T_DIV; }
\.               { shiftCursor(); return T_DOT; }
\>               { shiftCursor(); return T_GT; }
\<               { shiftCursor(); return T_LT; }
-                { shiftCursor(); return T_MINUS; }
%                { shiftCursor(); return T_MOD; }
\*               { shiftCursor(); return T_MULT; }
!                { shiftCursor(); return T_NOT; }
\+               { shiftCursor(); return T_PLUS; }
&&               { shiftCursor(); return T_AND; }
==               { shiftCursor(); return T_EQ; }
\>=              { shiftCursor(); return T_GEQ; }
\<\<             { shiftCursor(); return T_LEFTSHIFT; }
\<=              { shiftCursor(); return T_LEQ; }
!=               { shiftCursor(); return T_NEQ; }
\|\|             { shiftCursor(); return T_OR; }
\>\>             { shiftCursor(); return T_RIGHTSHIFT; }

bool             { shiftCursor(); return T_BOOLTYPE; }
break            { shiftCursor(); return T_BREAK; }
continue         { shiftCursor(); return T_CONTINUE; }
else             { shiftCursor(); return T_ELSE; }
extern           { shiftCursor(); return T_EXTERN; }
false            { shiftCursor(); return T_FALSE; }
for              { shiftCursor(); return T_FOR; }
func             { shiftCursor(); return T_FUNC; }
if               { shiftCursor(); return T_IF; }
int              { shiftCursor(); return T_INTTYPE; }
null             { shiftCursor(); return T_NULL; }
package          { shiftCursor(); return T_PACKAGE; }
return           { shiftCursor(); return T_RETURN; }
string           { shiftCursor(); return T_STRINGTYPE; }
true             { shiftCursor(); return T_TRUE; }
var              { shiftCursor(); return T_VAR; }
void             { shiftCursor(); return T_VOID; }
while            { shiftCursor(); return T_WHILE; }

{identifier}     { shiftCursor(); yylval.sval = new string(yytext); return T_IDENTIFIER; }
{whitespace}     { shiftCursor(true);  }
{comment}        { shiftCursor(true);  }
.                { shiftCursor(); return -1; }
%%

/*
// Function: yyerror
// --------------------------
//
//
//   Lexical Error Report
//
//   Parameters:
//       s: lexeme
//
*/
int
yyerror(const char *s) {
  cerr << "Line " << currentLine << ": " << s << " at char " << currentChar << endl;
  return 1;
}