module dcmp.variables;

import std.conv, std.string, std.stdio;
import dcmp.errors, dcmp.recognizers, dcmp.functions, dcmp.token, dcmp.parser, dcmp.procedures;

struct Variable{
  string name;
  string type    = "int";          // char / short / int / float
  string loc     = "global";       // Global / Argument / Local
  int    offset  = 0;              // Offset in the stack
  int    nelems  = 1;              // Number of elements

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

Variable[] variables; // All variables

/* Lookup a variable by name */
Variable getVariable(string name){
  if(functions.length > 0){
    foreach(v; functions[($-1)].vscope){ if(name == v.name) return v; }
  }
  foreach(v; variables){ if(name == v.name) return v; }
  undefined(name); assert(0);
}

/* Get a list of all variables */
string[] getVariables(){
  string[] r;
  if(functions.length > 0){
    foreach(v; functions[($-1)].vscope){ r ~= v.name; }
  }
  foreach(v; variables){ r ~= v.name; }
  return r;
}

/* Matches the array index of a variable a[1] or a[10] */
int matchArrayIndex(ref Parser p){
  int n = 0;
  if(p.lookAhead.value == "["){             // Array variable allocation
    p.matchValue("[");
    n = to!int(p.matchType("numeric").value);
    p.matchValue("]");
  }
  return n;
}

int getOffset(Variable[] vars, string loc = "local"){
  int offset = 0;
  foreach(v; vars){
    if(v.loc == loc) offset += (v.size * v.nelems);
  }
  return offset;
}

/* Allocate a variable (so that it is added to the .bss section) */
Variable allocateVariable(ref Parser p, string name, string type, bool inFunction){
  if(inTable(name, getVariables())) duplicate(name);
  int n = p.matchArrayIndex();
  if(n == 0) n = 1;
  Variable v = Variable(name, type, "global", 0, n);
  if(!inFunction) variables ~= v;
  if(inFunction){
    int offset = getOffset(functions[($-1)].vscope);
    if(offset + v.size*v.nelems > LOCALSTACKSPACE){
      v.loc = "fglobal";
    }else{
      v.loc = "local";
      v.offset = offset;
    }
    functions[($-1)].vscope ~= v;
  }
  return v;
}

