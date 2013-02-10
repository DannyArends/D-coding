module dcmp.token;

import dcode.errors : expected;
import dcmp.parser;

struct Token{
  string value;
  string type;
}

Token getToken(ref Parser p){
  Token t = p.currentToken();
  p.lookAhead = p.nextToken();
  return t;
}

Token matchType(ref Parser p, string type){
  if(p.lookAhead.type == type) return p.getToken();
  expected(type, p.lookAhead.type); assert(0);
}

Token matchValue(ref Parser p, string value){
  if(p.lookAhead.value == value) return p.getToken();
  expected(value, p.lookAhead.value); assert(0);
}

