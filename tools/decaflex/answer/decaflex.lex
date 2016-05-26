
%{

#include <iostream>
#include <cstdlib>

using namespace std;

#define T_AND            128 // &&
#define T_ASSIGN         '='
#define T_BOOLTYPE       129 // bool
#define T_BREAK          130 // break
#define T_CHARCONSTANT   131 // char_lit (see section on Character literals)
#define T_COMMA          ','
#define T_COMMENT        132 // comment
#define T_CONTINUE       133 // continue
#define T_DIV            '/'
#define T_DOT            '.'
#define T_ELSE           134 // else
#define T_EQ             135 // ==
#define T_EXTERN         136 // extern
#define T_FALSE          137 // false
#define T_FOR            138 // for
#define T_FUNC           139 // func
#define T_GEQ            140 // >=
#define T_GT             '>'
#define T_ID             141 // identifier (see section on Identifiers)
#define T_IF             142 // if
#define T_INTCONSTANT    143 // int_lit (see section on Integer literals)
#define T_INTTYPE        144 // int
#define T_LCB            '{'
#define T_LEFTSHIFT      145 // <<
#define T_LEQ            146 // <=
#define T_LPAREN         '('
#define T_LSB            '['
#define T_LT             '<'
#define T_MINUS          '-'
#define T_MOD            '%'
#define T_MULT           '*'
#define T_NEQ            147 // !=
#define T_NOT            '!'
#define T_NULL           148 // null
#define T_OR             149 // ||
#define T_PACKAGE        150 // package
#define T_PLUS           '+'
#define T_RCB            '}'
#define T_RETURN         151 // return
#define T_RIGHTSHIFT     152 // >>
#define T_RPAREN         ')'
#define T_RSB            ']'
#define T_SEMICOLON      ';'
#define T_STRINGCONSTANT 153 // string_lit (see section on String literals)
#define T_STRINGTYPE     154 // string
#define T_TRUE           155 // true
#define T_VAR            156 // var
#define T_VOID           157 // void
#define T_WHILE          158 // while
#define T_WHITESPACE     159 // whitespace (see section on Whitespace)
%}

/* regexp definitions */
num [0-9]+

%%
  /*
    Pattern definitions for all tokens
  */
func                       { return T_FUNC; }
int                        { return T_INTTYPE; }
package                    { return T_PACKAGE; }
\{                         { return T_LCB; }
\}                         { return T_RCB; }
\(                         { return T_LPAREN; }
\)                         { return T_RPAREN; }
\;                         { return T_SEMICOLON; }
[a-zA-Z\_][a-zA-Z\_0-9]*   { return T_ID; }
[\t\r\a\v\b ]+             { return T_WHITESPACE; }
\n                         { return 10; }
.                          { cerr << "Error: unexpected character in input" << endl; return -1; }
%%

int main () {
  int token;
  string lexeme;
  while ((token = yylex())) {
    if (token > 0) {
      lexeme.assign(yytext);
	  switch(token) {
		case T_FUNC:    cout << "Tt_FUNC " << lexeme << endl; break;
		case T_INTTYPE: cout << "Tt_INT " << lexeme << endl; break;
		case T_PACKAGE: cout << "Tt_PACKAGE " << lexeme << endl; break;
		case T_LCB: cout << "Tt_LCB " << lexeme << endl; break;
		case T_RCB: cout << "Tt_RCB " << lexeme << endl; break;
		case T_LPAREN: cout << "Tt_LPAREN " << lexeme << endl; break;
		case T_RPAREN: cout << "Tt_RPAREN " << lexeme << endl; break;
		case T_ID: cout << "Tt_ID " << lexeme << endl; break;
		case T_WHITESPACE: cout << "Tt_WHITESPACE " << lexeme << endl; break;
		case 10: cout << "Tt_WHITESPACE \\n" << endl; break;
		default: exit(EXIT_FAILURE);
	  }
    } else {
      if (token < 0) {
		exit(EXIT_FAILURE);
      }
    }
  }
  exit(EXIT_SUCCESS);
}
