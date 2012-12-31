module dcmp.expressions;

import dcmp.errors, dcmp.token, dcmp.parser, dcmp.codegen_386;

/* Mathematical expression consists of 1 or more 'terms' separated by 'addops' */
void expression(ref Parser p){
  p.term();
  while(p.lookAhead.value == "+" || p.lookAhead.value == "-"){
    pushRegister();
    if(p.lookAhead.value == "+") p.add();
    if(p.lookAhead.value == "-") p.substract();
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
  }else{
    expected("expression / identifier or numeric", p.lookAhead.type);
  }
}

/* Assign an expression to a variable */
void assignment(ref Parser p, Token id){
  p.matchValue("=");
  p.expression();
  storeVariable(id.value);
}

void add(ref Parser p){
  p.matchValue("+");
  p.term();
  popAdd();
}

void substract(ref Parser p){
  p.matchValue("-");
  p.term();
  popSub();
}

void multiply(ref Parser p){
  p.matchValue("*");
  p.factor();
  popMul();
}

void divide(ref Parser p){
  p.matchValue("/");
  p.factor();
  popDiv();
}

