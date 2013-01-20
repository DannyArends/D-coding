module dcmp.variables;

import std.conv;
import dcmp.errors, dcmp.functions, dcmp.token, dcmp.parser, dcmp.procedures;

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

Variable[] variables; // All global variables

/* Get a global variable */
Variable getVariable(string name){
  foreach(v; variables){ if(name == v.name) return v; }
  undefined(name); assert(0);
}

/* Get a local variable */
Variable getLocal(string name){
  if(functions.length > 0){
    foreach(v; functions[($-1)].local){ if(name == v.name) return v; }
  }
  undefined(name); assert(0);
}

/* Get a list of all global variables */
string[] getVariables(){
  string[] r;
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

/* Allocate a variable (so that it is added to the .bss section) */
Variable allocateVariable(ref Parser p, string name, string type, bool inFunction){
  if(inTable(name, getVariables())) duplicate(name);
  int n = p.matchArrayIndex();
  if(n == 0) n = 1;
  Variable v = Variable(name, type, 0, n);
  if(!inFunction) variables ~= v;
  if(inFunction) functions[($-1)].local ~= v;
  return v;
}

