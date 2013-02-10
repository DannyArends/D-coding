module dcmp.procedures;

import std.conv, std.stdio;
import dcode.errors;
import dcmp.token, dcmp.expressions, dcmp.parser, dcmp.codegen_asm;
import dcmp.functions, dcmp.variables;

struct Function{
  string     name;
  string     type;
  Variable[] vscope;
}

Function[] functions; // All defined functions

/* Get a function by name */
Function getFunction(string name){
  foreach(f; functions){ if(f.name == name) return f; }
  undefined(name); assert(0);
}

/* Get all function names */
string[] getFunctionNames(){
  string[] r;
  foreach(f; functions){ r ~= f.name; }
  return r;
}

/* Parses and pushes supplied arguments to a function call */
void doFunctionCall(ref Parser p, Token func){
  p.matchValue("(");
  if(p.lookAhead.value != ")"){
    p.bexpression();                        // Parse and
    pushRegister();                         // Push the first argument to the function
    while(p.lookAhead.value == ","){
      p.matchValue(",");
      p.bexpression();                      // Parse and
      pushRegister();                       // Push the other argument to the function
    }
  }
  p.matchValue(")");                        // Todo: Match the supplied args with the argumentlist
  callFunction(func.value);                 // Call the function
}

/* Parses the arguments to a function call so that we can dereference when writing the function block */
Function doArgsDefinitionList(ref Parser p, string name, string t){
  Function f = Function(name, t);
  int offset = 0;
  p.matchValue("(");
  if(p.lookAhead.value != ")"){
    Token  type = p.matchType("type");
    Token  id   = p.matchType("identifier");
    f.vscope ~= Variable(id.value, type.value, "argument", offset);
    while(p.lookAhead.value == ","){
      p.matchValue(",");
      type      = p.matchType("type");
      id        = p.matchType("identifier");
      offset   += f.vscope[($-1)].size;
      f.vscope ~= Variable(id.value, type.value, "argument", offset);
    }
  }
  p.matchValue(")");
  return f;
}

