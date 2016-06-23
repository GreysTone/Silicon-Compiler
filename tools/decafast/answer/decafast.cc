
#include "decafast-defs.h"
#include <list>
#include <ostream>
#include <iostream>
#include <sstream>

#ifndef YYTOKENTYPE
#include "decafast.tab.h"
#endif

using namespace std;

/// decafAST - Base class for all abstract syntax tree nodes.
class decafAST {
public:
  virtual ~decafAST() {}
  virtual string str() { return string(""); }
};

string getString(decafAST *d) {
	if (d != NULL) {
		return d->str();
	} else {
		return string("None");
	}
}

template <class T>
string commaList(list<T> vec) {
    string s("");
    for (typename list<T>::iterator i = vec.begin(); i != vec.end(); i++) {
        s = s + (s.empty() ? string("") : string(",")) + (*i)->str();
    }
    if (s.empty()) { 
        s = string("None");
    }
    return s;
}

/// decafStmtList - List of Decaf statements
class decafStmtList : public decafAST {
public:
	list<decafAST *> stmts;

	decafStmtList() {}
	~decafStmtList() {
		for (list<decafAST *>::iterator i = stmts.begin(); i != stmts.end(); i++) {
			delete *i;
		}
	}
	int size() { return stmts.size(); }
	void push_front(decafAST *e) { stmts.push_front(e); }
	void push_back(decafAST *e) { stmts.push_back(e); }
	virtual string str() { return commaList<class decafAST *>(stmts); }
};

class PackageAST : public decafAST {
	string Name;
	decafStmtList *FieldDeclList;
	decafStmtList *MethodDeclList;
public:
	PackageAST(string name, decafStmtList *fieldlist, decafStmtList *methodlist)
	  : Name(name), FieldDeclList(fieldlist), MethodDeclList(methodlist) {}
	~PackageAST() {
	  if (FieldDeclList != NULL) { delete FieldDeclList; }
	  if (MethodDeclList != NULL) { delete MethodDeclList; }
	}
	string str() {
	  return string("Package") + "(" + Name + "," + getString(FieldDeclList) + "," + getString(MethodDeclList) + ")";
	}
};

/// ProgramAST - the decaf program
class ProgramAST : public decafAST {
	decafStmtList *ExternList;
	PackageAST *PackageDef;
public:
	ProgramAST(decafStmtList *externs, PackageAST *c) : ExternList(externs), PackageDef(c) {}
	~ProgramAST() {
	  if (ExternList != NULL) { delete ExternList; }
	  if (PackageDef != NULL) { delete PackageDef; }
	}
	string str() { return string("Program") + "(" + getString(ExternList) + "," + getString(PackageDef) + ")"; }
};

enum class decafType : std::int8_t {
  voidType,
  charType,
  boolType,
  integerType,
  stringType,
};

/// Type
class AtomType : public decafAST {
  string TypeName;
  decafType Spec;
public:
  AtomType(string name, decafType t) : TypeName(name), Spec(t) {}
  ~AtomType() {}
  string str() {
    return TypeName;
  }
};

class ConstantAST : public decafAST {
  decafType type;
  std::string data;
public:
  ConstantAST(decafType t, string d) : type(t), data(d) {}
  ~ConstantAST() {}

  string str() {
    string output;
    switch (type) {
      case decafType::integerType:
      {
        output = "NumberExpr(" + data + ")";
        break;
      }
      case decafType::charType:
      {
        int ch = data[1];
        // escape char
        if(ch == 92) {
          ch = data[2];
          switch (ch) {
            case 'n':
              ch = 10;
              break;
            case 'r':
              ch = 13;
              break;
            case 't':
              ch = 9;
              break;
           case 'v':
              ch = 11;
              break;
           case 'f':
              ch = 12;
              break;
            case 'a':
              ch = 7;
              break;
            case 'b':
              ch = 8;
              break;
            default:
              break;
          }
        }
        output = "NumberExpr(" + std::to_string(ch) + ")";
        break;
      }
      case decafType::stringType:
      {
        output = "StringConstant(" + data + ")";
        break;
      }
      case decafType::boolType:
      {
        output = "BoolExpr(" + data + ")";
        break;
      }
      default:
      {
        output = "UnknownConstant()";
        break;
      }
    }
    return output;
  }
};

class IdAST : public decafAST {
public:
  list<string> idlist;
  IdAST(string name) { idlist.push_back(name); }
  ~IdAST() {}
  string str() {
    return *(idlist.begin());
  }
};


class TypeAST : public decafAST {
  decafAST *Type;
  bool IsArray;
  string Range;
public:
  TypeAST(decafAST *t, string r = "", bool i = false) : Type(t), Range(r), IsArray(i) {}
  ~TypeAST() {
    if (Type != NULL) { delete Type; }
  }
  string str() {
    if (!IsArray) return Type->str() + ",Scalar";
    else return Type->str() + ",Array(" + Range  + ")";
  }
};

class IdTypeComp : public decafAST {
  string name;
  decafAST *type;
public:
  IdTypeComp(string n, decafAST *t) : name(n), type(t) {}
  ~IdTypeComp() {
    //if(type) delete type;
  }
  string str() {
    return "VarDef(" + name + "," + type->str() + ")";
  }
};

/// ExternFunctionAST
class ExternFunctionAST : public decafAST {
  string Name;
  decafAST *Type;
  decafStmtList *VarDefList;
public:
  ExternFunctionAST(string name, decafAST *type, decafStmtList *vardeflist)
    : Name(name), Type(type), VarDefList(vardeflist) {}
  ~ExternFunctionAST() {
    if (Type != NULL) { delete Type; }
    if (VarDefList != NULL) { delete VarDefList; }
  }
  string str() {
    if(VarDefList->size())
      return string("ExternFunction") + "(" + Name + "," + Type->str() + ",VarDef(" + getString(VarDefList) + "))";
    else
      return string("ExternFunction") + "(" + Name + "," + Type->str() + "," + getString(VarDefList) + ")";
  }
};


/// FieldDecl
class FieldDeclAST : public decafAST {
  string FieldDeclName;
  decafAST *Type;
  ConstantAST *Data;
  bool isAssignGlobal;
public:
  FieldDeclAST(string name, decafAST *t, ConstantAST *d = NULL, bool o = false)
      : FieldDeclName(name), Type(t), Data(d), isAssignGlobal(o) {}
  ~FieldDeclAST() {}
  string str() {
    if (!isAssignGlobal)  
      return "FieldDecl(" + FieldDeclName + "," + Type->str() + ")";
    else
      return "AssignGlobalVar(" + FieldDeclName + "," + Type->str() + "," + Data->str() + ")";
  } 
};

/// MethodDecl
class MethodDeclAST : public decafAST {
  string MethodDeclName;
  decafAST *ReturnType;
  decafStmtList *ParamList;
  decafStmtList *Block;
public:
  MethodDeclAST(string n, decafAST *t, decafStmtList *p, decafStmtList *b)
      : MethodDeclName(n), ReturnType(t), ParamList(p), Block(b) {}
  ~MethodDeclAST() {
    if (ReturnType) delete ReturnType;
    if (ParamList) delete ParamList;
    if (Block) delete Block;
  }
  string str() {
    return "Method(" + MethodDeclName + "," + ReturnType->str() + "," + getString(ParamList) + ",Method" + getString(Block) + ")";
  }
};

/// BlockAST
class BlockAST : public decafAST {
	decafStmtList *VarDeclList;
	decafStmtList *StmtList;
public:
	BlockAST(decafStmtList *v, decafStmtList *s) : VarDeclList(v), StmtList(s) {}
	~BlockAST() {
	  if (VarDeclList) { delete VarDeclList; }
	  if (StmtList) { delete StmtList; }
	}
	string str() { return string("Block") + "(" + getString(VarDeclList) + "," + getString(StmtList) + ")"; }
};

enum class decafStmt : std::int8_t {
  S_IF,
  S_WHILE,
  S_FOR,
  S_RETURN,
  S_BREAK,
  S_CONTINUE,
  S_ASSIGN,
  S_METHOD_CALL,
  S_BLOCK,
}; 

class StmtAST : public decafAST {
  decafAST *stmt;
  decafStmt spec;
public:
  StmtAST(decafAST *s, decafStmt sp) : stmt(s), spec(sp) {}
  ~StmtAST() {
    if (stmt) delete stmt;
  }
  string str() {
    switch (spec) {
      case decafStmt::S_BLOCK:
      case decafStmt::S_METHOD_CALL:
      case decafStmt::S_ASSIGN:
        return stmt->str();
      case decafStmt::S_BREAK:
        return string("BreakStmt");
      case decafStmt::S_CONTINUE:
        return string("ContinueStmt");
      case decafStmt::S_IF:
      case decafStmt::S_WHILE:
      case decafStmt::S_FOR:
      case decafStmt::S_RETURN:
        return stmt->str();
    }
  }
};

class MethodCallAST : public decafAST {
  string name;
  decafAST *argList;
public:
  MethodCallAST(string n, decafAST *a = NULL) : name(n), argList(a) {}
  ~MethodCallAST() {
    if(argList) delete argList;
  }
  string str() {
    if(!argList)
      return "MethodCall(" + name + ",None)";
    else
      return "MethodCall(" + name + "," + argList->str() + ")";
  }
};

class AssignAST : public decafAST {
  string name;
  decafAST *expr;
  decafAST *index;
public:
  AssignAST(string n, decafAST *e, decafAST *i = NULL)
      : name(n), expr(e), index(i) {}
  ~AssignAST() {
    if(expr) delete expr;
    if(index) delete index;
  }
  string str() {
    if(!index) 
      return "AssignVar(" + name + "," + expr->str() + ")";
    else
      return "AssignArrayLoc(" + name + "," + index->str() + "," + expr->str() + ")";
  }
};

enum class decafOperator : std::int8_t {
  NOT,
  UMINUS,
  PLUS,
  BMINUS,
  MULT,
  DIV,
  LSHIFT,
  RSHIFT,
  MOD,
  EQ,
  NEQ,
  LT,
  LEQ,
  GT,
  GEQ,
  AND,
  OR,
};

class UnaryOpAST : public decafAST {
  decafOperator op;
  decafAST *operand;
public:
  UnaryOpAST(decafOperator o, decafAST *od) : op(o), operand(od) {}
  ~UnaryOpAST() {
    if(operand) delete operand;
  }
  string str() {
    string head;
    switch (op) {
      case decafOperator::NOT:
        head = "Not"; break;
      case decafOperator::UMINUS:
        head = "UnaryMinus"; break;
      default:
        head = "NotUnaryOp"; break;
    }
    return "UnaryExpr(" + head + "," + operand->str() + ")";
  }
};

class BinaryOpAST : public decafAST {
  decafOperator op;
  decafAST *operand1;
  decafAST *operand2;
public:
  BinaryOpAST(decafOperator o, decafAST *od1, decafAST *od2) 
      : op(o), operand1(od1), operand2(od2) {}
  ~BinaryOpAST() {
    if(operand1) delete operand1;
    if(operand2) delete operand2;
  }
  string str() {
    string head;
    switch (op) {
      case decafOperator::PLUS:
        head = "Plus"; break;
      case decafOperator::BMINUS:
        head = "Minus"; break;
      case decafOperator::MULT:
        head = "Mult"; break;
      case decafOperator::DIV:
        head = "Div"; break;
      case decafOperator::LSHIFT:
        head = "Leftshift"; break;
      case decafOperator::RSHIFT:
        head = "Rightshift"; break;
      case decafOperator::MOD:
        head = "Mod"; break;
      case decafOperator::EQ:
        head = "Eq"; break;
      case decafOperator::NEQ:
        head = "Neq"; break;
      case decafOperator::LT:
        head = "Lt"; break;
      case decafOperator::LEQ:
        head = "Leq"; break;
      case decafOperator::GT:
        head = "Gt"; break;
      case decafOperator::GEQ:
        head = "Geq"; break;
      case decafOperator::AND:
        head = "And"; break;
      case decafOperator::OR:
        head = "Or"; break;
      default:
        head = "NotBinOp"; break;
    }
    return "BinaryExpr(" + head + "," + operand1->str() + "," + operand2->str() + ")"; 
  }
};

class ExprAST : public decafAST {
  decafAST *content;
public:
  ExprAST(decafAST *c) : content(c) {}
  ~ExprAST() {
    if(content) delete content;
  }
  string str() {
    return content->str();
  }
};

class RValueAST : public decafAST {
  string name;
  decafAST *index;
public:
  RValueAST(string n, decafAST *i = NULL) : name(n), index(i) {}
  ~RValueAST() {
    if(index) delete index;
  }
  string str() {
    if(!index) 
      return "VariableExpr(" + name + ")";
    else
      return "ArrayLocExpr(" + name + "," + index->str() + ")";
  }
};

class IfStmtAST : public decafAST {
  decafAST *expr;
  decafAST *ifBlock;
  decafAST *elseBlock;
public:
  IfStmtAST(decafAST *e, decafAST *ib, decafAST *eb = NULL)
      : expr(e), ifBlock(ib), elseBlock(eb) {}
  ~IfStmtAST() {
    if(expr) delete expr;
    if(ifBlock) delete ifBlock;
    if(elseBlock) delete elseBlock;
  }
  string str() {
    if(!elseBlock) 
      return string("IfStmt(") + expr->str() + "," + ifBlock->str() + ",None)";
    else 
      return string("IfStmt(") + expr->str() + "," + ifBlock->str() + "," + elseBlock->str() + ")";
  }
};

class ReturnStmtAST : public decafAST {
  decafAST *expr;
public:
  ReturnStmtAST(decafAST *e = NULL) : expr(e) {}
  ~ReturnStmtAST() {
    if(expr) delete expr;
  }
  string str() {
    if(!expr)
      return "ReturnStmt(None)";
    else
      return string("ReturnStmt(") + expr->str() + ")";
  }
};

class WhileStmtAST : public decafAST {
  decafAST *expr;
  decafAST *block;
public:
  WhileStmtAST(decafAST *e, decafAST *b) : expr(e), block(b) {}
  ~WhileStmtAST() {
    if(expr) delete expr;
    if(block) delete block;
  }
  string str() {
    return "WhileStmt(" + expr->str() + "," + block->str() + ")";
  }
};

class ForStmtAST : public decafAST {
  decafAST *pre_assign;
  decafAST *condition;
  decafAST *loop_assign;
  decafAST *block;
public:
  ForStmtAST(decafAST *pa, decafAST *c, decafAST *la, decafAST *b)
      : pre_assign(pa), condition(c), loop_assign(la), block(b) {}
  ~ForStmtAST() {
    if(pre_assign) delete pre_assign;
    if(condition) delete condition;
    if(loop_assign) delete loop_assign;
    if(block) delete block;
  }
  string str() {
    return "ForStmt(" + pre_assign->str() + "," + condition->str() + "," + loop_assign->str() + "," + block->str() + ")" ;
  }
}; 

