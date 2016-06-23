%{
#include <iostream>
#include <ostream>
#include <string>
#include <cstdlib>
#include "decafast-defs.h"

int yylex(void);
int yyerror(char *);

// print AST?
bool printAST = true;

#include "decafast.cc"

using namespace std;

%}

%union{
    class decafAST *ast;
    std::string *sval;
 }

%token T_COMMA T_LPAREN T_LCB T_LSB T_RCB T_RPAREN T_RSB T_SEMICOLON
%token T_AND T_ASSIGN T_DIV T_DOT T_EQ T_GEQ T_GT T_LEFTSHIFT T_LEQ T_LT T_MINUS T_MOD T_MULT T_NEQ T_NOT T_OR T_PLUS T_RIGHTSHIFT
%token T_BOOLTYPE T_BREAK T_CONTINUE T_ELSE T_EXTERN T_FALSE T_FOR T_FUNC T_IF T_INTTYPE T_NULL T_PACKAGE T_RETURN T_STRINGTYPE T_TRUE T_VAR T_VOID T_WHILE
%token <sval> T_CHARCONSTANT
%token <sval> T_INTCONSTANT
%token <sval> T_STRINGCONSTANT
%token <sval> T_IDENTIFIER
/*%token T_WHITESPACE*/
/*%token T_COMMENT*/

%type <ast> decafpackage
%type <ast> field_decl_0list field_decl method_decl_0list method_decl extern_0list
%type <ast> identifier_1commalist
%type <ast> extern_define extern_type method_type type
%type <ast> extern_type_1commalist
%type <ast> array_type
%type <ast> constant bool_constant
%type <ast> block
%type <ast> statement_0list var_decl_0list method_decl_1commalist
%type <ast> var_decl statement
%type <ast> expr
%type <ast> method_arg_1commalist method_arg assign_1list assign method_call

%left T_OR
%left T_AND
%left T_EQ T_NEQ T_LE T_LEQ T_GE T_GEQ
%left T_PLUS T_MINUS
%left T_MULT T_DIV T_MOD T_LEFTSHIFT T_RIGHTSHIFT
%left T_NOT
%left UM
%%

start: program

program: 
      extern_0list decafpackage { 
        ProgramAST *prog = new ProgramAST((decafStmtList *)$1, (PackageAST *)$2);
	      if (printAST) cout << getString(prog) << endl;
        delete prog;
      } 
    ;

decafpackage: 
      T_PACKAGE T_IDENTIFIER T_LCB field_decl_0list method_decl_0list T_RCB { 
        $$ = new PackageAST(*$2, (decafStmtList *)$4, (decafStmtList *)$5);
        delete $2;
      }
    ;

extern_0list:
      extern_define extern_0list {
          decafStmtList *slist = new decafStmtList();
          slist->push_back((decafAST *)$1);
          slist->push_back($2);
          $$ = slist;
        }
    | extern_define {
          decafStmtList *slist = new decafStmtList(); 
          slist->push_back((decafAST *)$1);
          $$ = slist; 
        }
    | { $$ = new decafStmtList(); }
    ;

extern_define:
      T_EXTERN T_FUNC T_IDENTIFIER T_LPAREN T_RPAREN method_type T_SEMICOLON {
        $$ = new ExternFunctionAST(*$3, $6, new decafStmtList());
        delete $3;
      }
    | T_EXTERN T_FUNC T_IDENTIFIER T_LPAREN extern_type_1commalist T_RPAREN method_type T_SEMICOLON {
          $$ = new ExternFunctionAST(*$3, $7, (decafStmtList *)$5);
          delete $3;
        }
    ;

extern_type_1commalist:
      extern_type_1commalist T_COMMA extern_type {
          decafStmtList *slist = new decafStmtList(); 
          slist->push_back($1);
          slist->push_back((decafAST *)$3);
          $$ = slist;
        }
    | extern_type {
          decafStmtList *slist = new decafStmtList(); 
          slist->push_back((decafAST *)$1);
          $$ = slist;
        }
    ;

field_decl_0list:
      field_decl field_decl_0list {
        decafStmtList *slist = new decafStmtList; 
        slist->push_back($1);
        slist->push_back($2);
        $$ = slist;
      }
    | field_decl {
        decafStmtList *slist = new decafStmtList; 
        slist->push_back($1); 
        $$ = slist;
      }
    | { $$ = new decafStmtList; }
    ;

field_decl:
      T_VAR identifier_1commalist type T_SEMICOLON {
        IdAST *idList = (IdAST *)$2;
        decafStmtList *slist = new decafStmtList;
        for(auto it = (*idList).idlist.begin(); it != (*idList).idlist.end(); ++it) {
          TypeAST *type = new TypeAST((AtomType *)$3);
          FieldDeclAST *decl = new FieldDeclAST((*it), type);
          slist->push_back(decl);
        }
        $$ = slist;
        delete idList;
      }
    | T_VAR identifier_1commalist array_type T_SEMICOLON {
        IdAST *idList = (IdAST *)$2;
        decafStmtList *slist = new decafStmtList;
        for(auto it = (*idList).idlist.begin(); it != (*idList).idlist.end(); ++it) {
          FieldDeclAST *decl = new FieldDeclAST((*it), (TypeAST *)$3);
          slist->push_back(decl);
        }
        $$ = slist;
        delete idList;
      }
    | T_VAR identifier_1commalist type T_ASSIGN constant T_SEMICOLON {
        IdAST *idList = (IdAST *)$2;
        decafStmtList *slist = new decafStmtList;
        if((*idList).idlist.size() > 1) return 1;
        for(auto it = (*idList).idlist.begin(); it != (*idList).idlist.end(); ++it) {
          FieldDeclAST *decl = new FieldDeclAST((*it), $3, (ConstantAST *)$5, true);
          slist->push_back(decl);
        }
        $$ = slist;
        delete idList;
      }
    /*| T_VAR T_IDENTIFIER type T_ASSIGN constant T_SEMICOLON {
        decafStmtList *slist = new decafStmtList;
        FieldDeclAST *decl = new FieldDeclAST(*$2, $3, (ConstantAST *)$5, true); 
        slist->push_back(decl);
        $$ = slist;
        delete $2;
      }*/
    ;

method_decl_0list:
      method_decl method_decl_0list {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        slist->push_back($2);
        $$ = slist;
      }
    | method_decl {
        decafStmtList *slist = new decafStmtList; 
        slist->push_back($1); 
        $$ = slist;
      }
    | { $$ = new decafStmtList; }
    ;

method_decl:
      T_FUNC T_IDENTIFIER T_LPAREN T_RPAREN method_type block {
        $$ = new MethodDeclAST(*$2, $5, new decafStmtList, (decafStmtList *)$6);
      }
    | T_FUNC T_IDENTIFIER T_LPAREN method_decl_1commalist T_RPAREN method_type block {
        $$ = new MethodDeclAST(*$2, $6, (decafStmtList *)$4, (decafStmtList *)$7);
      }
    ;

method_decl_1commalist:
      method_decl_1commalist T_COMMA T_IDENTIFIER type {
        decafStmtList *slist = new decafStmtList;
        IdTypeComp *idt = new IdTypeComp(*$3, $4);
        slist->push_back($1);
        slist->push_back(idt);
        $$ = slist;
        delete $3;
      }
    | T_IDENTIFIER type {
        decafStmtList *slist = new decafStmtList;
        IdTypeComp *idt= new IdTypeComp(*$1, $2);
        slist->push_back(idt);
        $$ = slist;
        delete $1;
      }
    ;

method_call:
      T_IDENTIFIER T_LPAREN T_RPAREN {
        $$ = new MethodCallAST(*$1);
        delete $1;
      }
    | T_IDENTIFIER T_LPAREN method_arg_1commalist T_RPAREN {
        $$ = new MethodCallAST(*$1, $3);
        delete $1;
      }
    ;

method_arg_1commalist:
      method_arg_1commalist T_COMMA method_arg {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        slist->push_back($3);
        $$ = slist;
      }
    | method_arg {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        $$ = slist;
      }
    ;

method_arg:
      expr { $$ = $1; }
    | T_STRINGCONSTANT { $$ = new ConstantAST(decafType::stringType, *$1); delete $1; }
    ;

statement: 
      T_IF T_LPAREN expr T_RPAREN block {
        IfStmtAST *ifs = new IfStmtAST((decafAST *)new ExprAST($3), $5);
        $$ = new StmtAST(ifs, decafStmt::S_IF);
      }
    | T_IF T_LPAREN expr T_RPAREN block T_ELSE block {
        IfStmtAST *ifs = new IfStmtAST((decafAST *)new ExprAST($3), $5, $7);
        $$ = new StmtAST(ifs, decafStmt::S_IF); 
      }
    | T_WHILE T_LPAREN expr T_RPAREN block {
        WhileStmtAST *whs = new WhileStmtAST((decafAST *)new ExprAST($3), $5);
        $$ = new StmtAST(whs, decafStmt::S_WHILE); 
      }
    | T_FOR T_LPAREN assign_1list T_SEMICOLON expr T_SEMICOLON assign_1list T_RPAREN block {
        ForStmtAST *fos = new ForStmtAST($3, (decafAST *)new ExprAST($5), $7, $9);
        $$ = new StmtAST(fos, decafStmt::S_FOR); 
      }
    | T_RETURN T_SEMICOLON {
        ReturnStmtAST *rets = new ReturnStmtAST();
        $$ = new StmtAST(rets, decafStmt::S_RETURN)
      }
    | T_RETURN T_LPAREN T_RPAREN T_SEMICOLON {
        ReturnStmtAST *rets = new ReturnStmtAST();
        $$ = new StmtAST(rets, decafStmt::S_RETURN)
      }
    | T_RETURN T_LPAREN expr T_RPAREN T_SEMICOLON {
        ReturnStmtAST *rets = new ReturnStmtAST($3);
        $$ = new StmtAST(rets, decafStmt::S_RETURN)
      }
    | T_BREAK T_SEMICOLON { $$ = new StmtAST(NULL, decafStmt::S_BREAK); }
    | T_CONTINUE T_SEMICOLON { $$ = new StmtAST(NULL, decafStmt::S_CONTINUE); }
    | assign T_SEMICOLON { $$ = new StmtAST($1, decafStmt::S_ASSIGN); }
    | method_call T_SEMICOLON { $$ = new StmtAST($1, decafStmt::S_METHOD_CALL); }
    | block { $$ = new StmtAST($1, decafStmt::S_BLOCK); }
    ;

block:
      T_LCB var_decl_0list statement_0list T_RCB {
        $$ = new BlockAST((decafStmtList *)$2, (decafStmtList *)$3);
      }
    ;

statement_0list:
      statement statement_0list {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        slist->push_back($2);
        $$ = slist;
      }
    | statement {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        $$ = slist;
    }
    | { $$ = new decafStmtList; }
    ;

var_decl_0list:
      var_decl var_decl_0list {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        slist->push_back($2);
        $$ = slist;
      }
    | var_decl {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        $$ = slist;
      }
    | { $$ = new decafStmtList; }
    ;

var_decl:
      T_VAR identifier_1commalist type T_SEMICOLON {
        IdAST *idList = (IdAST *)$2;
        decafStmtList *slist = new decafStmtList;
        for(auto it = (*idList).idlist.begin(); it != (*idList).idlist.end(); ++it) {
          IdTypeComp *idt = new IdTypeComp((*it), $3);
          slist->push_back(idt);
        }
        $$ = slist;
        delete idList;
      }
    ;

identifier_1commalist:
      identifier_1commalist T_COMMA T_IDENTIFIER {
        IdAST *idn = (IdAST *)$1;
        idn->idlist.push_back(*$3);
        $$ = idn;
        delete $3;
      }
    | T_IDENTIFIER { $$ = new IdAST(*$1); delete $1; }
    ;

assign_1list:
      assign assign_1list {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        slist->push_back($2);
        $$ = slist;
      }
    | assign {
        decafStmtList *slist = new decafStmtList;
        slist->push_back($1);
        $$ = slist;
      }
    ;

assign:
      T_IDENTIFIER T_ASSIGN expr { $$ = new AssignAST(*$1, $3); delete $1; }
    | T_IDENTIFIER T_LSB expr T_RSB T_ASSIGN expr { $$ = new AssignAST(*$1, $6, $3); delete $1; }
    ;

/* (embedded in assign)
lvalue:
      T_IDENTIFIER {}
    | T_IDENTIFIER T_LSB expr T_RSB {}
    ;
*/

expr:
      T_IDENTIFIER T_LSB expr T_RSB { $$ = new RValueAST(*$1, $3); delete $1; }
    | T_IDENTIFIER { $$ = new RValueAST(*$1); delete $1; }
    | T_LPAREN expr T_RPAREN { $$ = $2; }
    | T_NOT expr { $$ = new UnaryOpAST(decafOperator::NOT, $2); }
    | T_MINUS expr %prec UM{ $$ = new UnaryOpAST(decafOperator::UMINUS, $2); }
    | constant { $$ = $1; }
    | method_call { $$ = $1; }
    | expr T_PLUS expr { $$ = new BinaryOpAST(decafOperator::PLUS, $1, $3); }
    | expr T_MINUS expr { $$ = new BinaryOpAST(decafOperator::BMINUS, $1, $3); }
    | expr T_MULT expr { $$ = new BinaryOpAST(decafOperator::MULT, $1, $3); }
    | expr T_DIV expr { $$ = new BinaryOpAST(decafOperator::DIV, $1, $3); }
    | expr T_LEFTSHIFT expr { $$ = new BinaryOpAST(decafOperator::LSHIFT, $1, $3); }
    | expr T_RIGHTSHIFT expr { $$ = new BinaryOpAST(decafOperator::RSHIFT, $1, $3); }
    | expr T_MOD expr { $$ = new BinaryOpAST(decafOperator::MOD, $1, $3); }
    | expr T_EQ expr { $$ = new BinaryOpAST(decafOperator::EQ, $1, $3); } 
    | expr T_NEQ expr { $$ = new BinaryOpAST(decafOperator::NEQ, $1, $3); } 
    | expr T_LT expr { $$ = new BinaryOpAST(decafOperator::LT, $1, $3); }
    | expr T_LEQ expr { $$ = new BinaryOpAST(decafOperator::LEQ, $1, $3); }
    | expr T_GT expr { $$ = new BinaryOpAST(decafOperator::GT, $1, $3); }
    | expr T_GEQ expr { $$ = new BinaryOpAST(decafOperator::GEQ, $1, $3); }
    | expr T_AND expr { $$ = new BinaryOpAST(decafOperator::AND, $1, $3); }
    | expr T_OR expr { $$ = new BinaryOpAST(decafOperator::OR, $1, $3); }
    ;

extern_type:
      T_STRINGTYPE { $$ = new AtomType("StringType", decafType::stringType); }
    | type { $$ = $1; }
    ;

method_type:
      T_VOID { $$ = new AtomType("VoidType", decafType::voidType); }
    | type { $$ = $1; }
    ;

array_type:
      T_LSB T_INTCONSTANT T_RSB type { $$ = new TypeAST($4, *$2, true); }
    ;

type: 
      T_INTTYPE { $$ = new AtomType("IntType", decafType::integerType); }
    | T_BOOLTYPE { $$ = new AtomType("BoolType", decafType::boolType); }
    ;

constant: 
      T_INTCONSTANT { $$ = new ConstantAST(decafType::integerType, *$1); delete $1; }
    | T_CHARCONSTANT { $$ = new ConstantAST(decafType::charType, *$1); delete $1; }
    | T_STRINGCONSTANT { $$ = new ConstantAST(decafType::stringType, *$1); delete $1; }
    | bool_constant { $$ = $1; }
    ;

bool_constant: 
      T_TRUE { $$ = new ConstantAST(decafType::boolType, "True"); }
    | T_FALSE { $$ = new ConstantAST(decafType::boolType, "False"); }
    ;
%%

int main() {
  // parse the input and create the abstract syntax tree
  int retval = yyparse();
  return(retval >= 1 ? EXIT_FAILURE : EXIT_SUCCESS);
}
