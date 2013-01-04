module dcmp.procedures;

import std.conv;
import dcmp.errors, dcmp.token, dcmp.expressions, dcmp.parser, dcmp.codegen_asm;
import dcmp.functions, dcmp.variables;

struct Function{
  string     name;
  string     type;
  Variable[] args;
  Variable[] local;
}

Function[] functions; // All defined functions

/* Get a list of all argument variables */
string[] getArgs(){
  string[] r;
  if(functions.length > 0){
    foreach(v; functions[($-1)].args){ r ~= v.name; }
  }
  return r;
}

/* Get a list of all local variables (unused) */
string[] getLocal(){
  string[] r;
  if(functions.length > 0){
    foreach(v; functions[($-1)].local){ r ~= v.name; }
  }
  return r;
}

/* Get the offset of a local argument variable by name */
string getArgOffset(string name){
  if(functions.length > 0){
    Variable[] vars = functions[($-1)].args;
    foreach(v; vars){
      if(name == v.name) return(to!string(((vars.length+1)*4) - v.offset));
    }
  }
  undefined(name); assert(0);
}

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
    f.args ~= Variable(id.value, type.value, offset);
    while(p.lookAhead.value == ","){
      p.matchValue(",");
      type    = p.matchType("type");
      id      = p.matchType("identifier");
      offset += 4;                                // TODO: Use sizeOf type
      f.args ~= Variable(id.value, type.value, offset);
    }
  }
  p.matchValue(")");
  return f;
}

