module dcmp.parser;

import std.stdio, std.conv;
import dcmp.token, dcmp.recognizers, dcmp.functions, dcmp.expressions;
import dcmp.procedures, dcmp.errors, dcmp.codegen_asm;

struct Parser{
  Token lookAhead;

  this(Token[] tokens){ this.tokens = tokens; lookAhead = tokens[0]; }
  Token nextToken(){
    ctok++;
    if(ctok >= tokens.length) abort("Unexpected end of input");
    return tokens[ctok];
  }
  Token currentToken(){ return tokens[ctok]; }

  LocalVEntry[] args;   // When inside a function we use offsets to the arguments and local variables
  private:
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
    p.matchStatement();
  }
  if(isFunction) functionEpilog();
  p.matchValue("}");
}

void matchStatement(ref Parser p){
  if(p.lookAhead.type == "type"){
    Token  type = p.matchType("type");              // Type is always followed by identifier
    Token  id   = p.matchType("identifier");
    if(p.lookAhead.value == "("){                   // Function declaration
      p.args = p.doArgsDefinitionList();
      string funlabel = addLabel(id.value, true);
      functionProlog();
      p.doBlock();
      addLabel(funlabel ~ "_end");
      p.args = [];
    }else if(p.lookAhead.value == "="){             // Variable allocation & assigment
      allocateVariable(id.value);
      p.assignment(id);
      p.matchValue(";");
    }else if(p.lookAhead.value == ","){             // Multiple variable allocation
      allocateVariable(id.value);
      while(p.lookAhead.value == ","){
        p.matchValue(",");
        id = p.matchType("identifier");
        allocateVariable(id.value);
      }
    }else if(p.lookAhead.value == ";"){             // Single variable allocation
      allocateVariable(id.value);
      p.matchValue(";");
    }
  }else if(p.lookAhead.type == "keyword"){          // Control statements
    Token keyw = p.matchType("keyword");
    if(keyw.value != "else"){
      p.matchValue("(");
      p.bexpression();
      p.matchValue(")");
    }
    p.doBlock(false);
  }else if(p.lookAhead.type == "identifier"){       // Variable manipulation or Function call
    Token  id   = p.matchType("identifier");
    if(p.lookAhead.value == "(") p.doArgsCallList(id);
    if(p.lookAhead.value == "=") p.assignment(id);
    p.matchValue(";");
  }else{
    expected("keyword / identifier / type", p.lookAhead.type);
  }
}

