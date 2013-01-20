module dcmp.expressions;

import std.stdio, std.string;
import dcmp.errors, dcmp.variables, dcmp.functions, dcmp.token;
import dcmp.parser, dcmp.procedures, dcmp.codegen_asm;

/* Mathematical expression consists of 1 or more 'terms' separated by 'addops' */
void expression(ref Parser p){
  p.term();
  while(isAddOp(p.lookAhead.value)){
    pushRegister();
    if(p.lookAhead.value == "+") p.add();
    if(p.lookAhead.value == "-") p.substract();
  }
}

/* Boolean expression consists of 1 or more 'boolean terms' separated by 'boolops' */
void bexpression(ref Parser p){
  p.bterm();
  while(p.lookAhead.value == "==" || p.lookAhead.value == "<>"){
    pushRegister();
    if(p.lookAhead.value == "==") p.equals();
    if(p.lookAhead.value == "<>") p.notEquals();
  }
}

/* A term consists of 1 or more 'factors' separated by 'mulops' */
void term(ref Parser p){
  p.factor();
  while(p.lookAhead.value == "*" || p.lookAhead.value == "/"){
    pushRegister();
    if(p.lookAhead.value == "*") return p.multiply();
    if(p.lookAhead.value == "/") return p.divide();
  }
}

/* A boolean term */
void bterm(ref Parser p){
  p.nbfactor();
  while(p.lookAhead.value == "&&" || p.lookAhead.value == "||"){
    pushRegister();
    p.matchType("operator");
    p.nbfactor();
    andBoolean();
  }
}

/* A boolean <-> integer relation term */
void relation(ref Parser p){
  p.expression();
  if(isRelOp(p.lookAhead.value)){
//    writefln("%s, %s",p.lookAhead.type,p.lookAhead.value);
    pushRegister();                             // TODO: Do we need this 1 line up ?
    if(p.lookAhead.value == "==") p.equals();
    if(p.lookAhead.value == "<>") p.notEquals();
    if(p.lookAhead.value == "<")  p.smaller();
    if(p.lookAhead.value == ">")  p.larger();
    if(p.lookAhead.value == "<=") p.smaller(true);
    if(p.lookAhead.value == ">=") p.larger(true);
  }
}

/* A negative boolean factor */
void nbfactor(ref Parser p){
  if(p.lookAhead.value == "!"){
    p.matchValue("!");
    p.bfactor();
    negateBoolean();
  }else{
    p.bfactor();
  }
}

/* A boolean factor */
void bfactor(ref Parser p){
  if(p.lookAhead.type == "boolean"){
    pushBoolean(p.matchType("boolean").value);
  }else{
    p.relation();
  }
}

/* A factor is an expression / identifier / Boolean or numeric */
void factor(ref Parser p){
  if(p.lookAhead.value == "("){                     // Brackets around arguments 1 + (6 + 9)
    p.matchValue("(");
    p.bexpression();
    p.matchValue(")");
  }else if(p.lookAhead.type == "identifier"){
    Token id = p.matchType("identifier");
    if(inTable(id.value, getVariables())){          // Variable: 1 + (x - y)
      Variable v = getVariable(id.value);
      int index  = p.matchArrayIndex();
      loadVariable(v, index * v.size);
    }else if(inTable(id.value, labels)){            // Function call in expression: 1 + sum(x) - y
      p.doFunctionCall(id);
    }else{
      writefln("In scope: %s", getVariables());
      undefined(id.value);
    }
  }else if(p.lookAhead.type == "numeric"){          // Numeric constant
    loadConstant(p.matchType("numeric").value);
  }else if(p.lookAhead.type == "boolean"){          // Boolean constant: true / false
    p.bfactor();
  }else if(p.lookAhead.type == "operator"){         // Operators should be - and !
    p.nbfactor();
  }else{
    expected("expression / identifier / or numeric", p.lookAhead.type);
  }
}

/* Assign an expression to a variable */
void assignment(ref Parser p, string name){
  Variable v = getVariable(name);
  int index  = p.matchArrayIndex();
  p.matchValue("=");
  if(p.lookAhead.value == "["){                        // Whole array assignment
    index = 0;
    p.matchValue("[");
    p.bexpression();
    storeVariable(v, index * v.size);
    while(p.lookAhead.value == ","){
      index++;
      p.matchValue(",");
      p.bexpression();
      storeVariable(v, index * v.size);
    }
    p.matchValue("]");
  }else{                                               // Single variable or array element
    p.bexpression();
    storeVariable(v, index * v.size);
  }
}

/* Add 2 terms */
void add(ref Parser p){
  p.matchValue("+");
  p.term();
  popAdd();
}

/* Substract 2 terms */
void substract(ref Parser p){
  p.matchValue("-");
  p.term();
  popSub();
}

/* Multiply 2 factors */
void multiply(ref Parser p){
  p.matchValue("*");
  p.factor();
  popMul();
}

/* Divide 2 factors */
void divide(ref Parser p){
  p.matchValue("/");
  p.factor();
  popDiv();
}

/* Test if 2 expressions are equal a == b */
void equals(ref Parser p){
  p.matchValue("==");
  p.expression();
  popEquals();
}

void smaller(ref Parser p, bool equal = false){
  p.matchType("operator");
  p.expression();
  popSmaller(equal);
}

void larger(ref Parser p, bool equal = false){
  p.matchType("operator");
  p.expression();
  popLarger(equal);
}

void notEquals(ref Parser p){
  p.matchValue("<>");
  p.expression();
  popNotEquals();
}

