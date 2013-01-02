module dcmp.expressions;

import dcmp.errors, dcmp.functions, dcmp.token, dcmp.parser, dcmp.codegen_asm;

/* Mathematical expression consists of 1 or more 'terms' separated by 'addops' */
void expression(ref Parser p){
  p.term();
  while(p.lookAhead.value == "+" || p.lookAhead.value == "-"){
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

void bterm(ref Parser p){
  p.nbfactor();
  while(p.lookAhead.value == "&&"){
    pushRegister();
    p.matchValue("&&");
    p.nbfactor();
    andBoolean();
  }
}

void relation(ref Parser p){
  p.expression();
  if(isRelOp(p.lookAhead.type)){
    pushRegister();
    if(p.lookAhead.value == "==") p.equals();
    if(p.lookAhead.value == "<>") p.notEquals();
    if(p.lookAhead.value == "<")  p.smaller();
    if(p.lookAhead.value == ">")  p.larger();
    emitTest();
  }
}

void nbfactor(ref Parser p){
  if(p.lookAhead.value == "!"){
    p.matchValue("!");
    p.bfactor();
    negateBoolean();
  }else{
    p.bfactor();
  }
}

void bfactor(ref Parser p){
  if(p.lookAhead.type == "boolean"){
    pushBoolean(p.matchType("boolean").value);
  }else{
    p.relation();
  }
}

/* A factor is an expression / identifier or numeric */
void factor(ref Parser p){
  if(p.lookAhead.value == "("){
    p.matchValue("(");
    p.expression();
    p.matchValue(")");
  }else if(p.lookAhead.type == "identifier"){
    loadVariable(p.matchType("identifier").value);
  }else if(p.lookAhead.type == "numeric"){
    loadConstant(p.matchType("numeric").value);
  }else if(p.lookAhead.type == "boolean"){
    p.bfactor();
  }else if(p.lookAhead.type == "operator"){
    p.bfactor();
  }else{
    expected("expression / identifier or numeric", p.lookAhead.type);
  }
}

/* Assign an expression to a variable */
void assignment(ref Parser p, Token id){
  p.matchValue("=");
  p.bexpression();
  storeVariable(id.value);
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

void equals(ref Parser p){
  p.matchValue("==");
  p.expression();
  popEquals();
}

void smaller(ref Parser p){
  p.matchValue("<");
  p.expression();
  popSmaller();
}

void larger(ref Parser p){
  p.matchValue(">");
  p.expression();
  popLarger();
}

void notEquals(ref Parser p){
  p.matchValue("<>");
  p.expression();
  popNotEquals();
}

