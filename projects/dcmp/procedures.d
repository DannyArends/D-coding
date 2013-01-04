module dcmp.procedures;

import std.conv;
import dcmp.errors, dcmp.token, dcmp.expressions, dcmp.parser, dcmp.codegen_asm;
import dcmp.functions;

struct Variable{
  string name;
  string type;                     // char / short / int / float
  int    offset;                   // Offset in the stack
  int    nelems = 1;               // Number of elements

  @property int size(){
    int s = 0;
    if(type == "char")  s = 1;
    if(type == "short") s = 2;
    if(type == "int")   s = 4;
    if(type == "float") s = 4;
    return s;
  }

  @property int bytesize(){
    return nelems * size();
  }
}

struct Function{
  string     name;
  string     type;
  Variable[] args;
  Variable[] local;
}

Variable[] variables; // All global variables
Function[] functions; // All defined functions

Variable getVariable(string name){
  foreach(v; variables){ if(name == v.name) return v; }
  undefined(name); assert(0);
}

string[] getVariables(){
  string[] r;
  foreach(v; variables){ r ~= v.name; }
  return r;
}

string[] getArgs(){
  string[] r;
  if(functions.length > 0){
    foreach(v; functions[($-1)].args){ r ~= v.name; }
  }
  return r;
}

string[] getLocal(){
  string[] r;
  if(functions.length > 0){
    foreach(v; functions[($-1)].local){ r ~= v.name; }
  }
  return r;
}

/* Get the offset of a scope local variable by name */
string getArgOffset(string name){
  if(functions.length > 0){
    Variable[] vars = functions[($-1)].args;
    foreach(v; vars){
      if(name == v.name) return(to!string(((vars.length+1)*4) - v.offset));
    }
  }
  undefined(name); assert(0);
}

Function getFunction(string name){
  foreach(f; functions){ if(f.name == name) return f; }
  undefined(name); assert(0);
}

string[] getFunctionNames(){
  string[] r;
  foreach(f; functions){ r ~= f.name; }
  return r;
}

/* Parses and pushes supplied arguments to a function call */
void doArgsCallList(ref Parser p, Token func){
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

