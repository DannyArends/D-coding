module dcmp.parser;

import std.stdio, std.conv, std.string;
import dcmp.token, dcmp.recognizers, dcmp.functions, dcmp.expressions, dcmp.variables;
import dcmp.procedures, dcmp.errors, dcmp.controlstructs, dcmp.codegen_asm;

struct Parser{
  Token lookAhead;

  this(Token[] tokens){ this.tokens = tokens; lookAhead = tokens[0]; }
  Token nextToken(){
    ctok++;
    if(ctok >= tokens.length) abort("Unexpected end of input");
    return tokens[ctok];
  }
  Token currentToken(){ return tokens[ctok]; }

  void nextLabel(){ curLabel++; }
  string getL1(){ return(format("_Cl%s_1", curLabel)); }
  string getL2(){ return(format("_Cl%s_2", curLabel)); }

  private:
    int     curLabel = 0;
    Token[] tokens;
    int     ctok = 0;
}

void parseProgram(ref Parser p){
  prolog();
  while(p.lookAhead.value[0] != EOI){
    p.matchStatement();
  }
  epilog();
}

void doBlock(ref Parser p, bool isFunction = true){
  p.matchValue("{");
  while(p.lookAhead.value != "}"){
    p.matchStatement(isFunction);
  }
  if(isFunction) functionEpilog();
  p.matchValue("}");
}

void doDeclaration(ref Parser p, Token  id, Token  type, bool isFunction){
  if(p.lookAhead.value == "("){                   // Function declaration
    functions ~= p.doArgsDefinitionList(id.value, type.value);
    string funlabel = addLabel(id.value, true);
    functionProlog();
    p.doBlock();
    addLabel(funlabel ~ "_end");
  }else if(p.lookAhead.value == "="){             // Variable allocation & assigment
    p.allocateVariable(id.value, type.value, isFunction);
    p.assignment(id.value);
    p.matchValue(";");
  }else if(p.lookAhead.value == ","){             // Multiple variable allocation
    p.allocateVariable(id.value, type.value, isFunction);
    while(p.lookAhead.value == ","){
      p.matchValue(",");
      id = p.matchType("identifier");
      p.allocateVariable(id.value, type.value, isFunction);
    }
  }else if(p.lookAhead.value == ";"){             // Single variable allocation
    p.allocateVariable(id.value, type.value, isFunction);
    p.matchValue(";");
  }else if(p.lookAhead.value == "["){             // Array allocation
    p.allocateVariable(id.value, type.value, isFunction);
    if(p.lookAhead.value == "="){                 // Array initialization
      p.assignment(id.value);
    }
    p.matchValue(";");
  }else{
    expected("( = , ; [", p.lookAhead.type);
  }
}

void matchStatement(ref Parser p, bool isFunction = false){
  if(p.lookAhead.type == "type"){                   // Declaration: int x
    Token  type = p.matchType("type");
    p.doDeclaration(p.matchType("identifier"), type, isFunction);
  }else if(p.lookAhead.type == "keyword"){          // Control statements: if, while
    Token keyword = p.matchType("keyword");
    p.controlStatement(keyword);
  }else if(p.lookAhead.type == "identifier"){       // Variable assignment or function call
    Token    id = p.matchType("identifier");
    if(p.lookAhead.value == "("){
      p.doFunctionCall(id);                         // Function call
    }else if(p.lookAhead.value == "[" || p.lookAhead.value == "="){
      p.assignment(id.value);                       // Variable assignment
    }else{
      expected("function call / variable assignment", p.lookAhead.type);
    }
    p.matchValue(";");
  }else{
    expected("keyword / identifier / type", p.lookAhead.type);
  }
}

