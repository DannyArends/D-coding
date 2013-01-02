module dcmp.functions;

import std.stdio, std.conv;
import dcmp.errors, dcmp.recognizers, dcmp.parser;

bool inTable(string n, string[] t){ return inTable(n, cast(immutable)t); }

bool inTable(string n, immutable(char[][]) t){
  for(int x=0; x< t.length ; x++){
    if(n == t[x]) return true; 
  }
  return false;
}

bool isAddOp(string s){ return inTable(s, addOps); }
bool isMulOp(string s){ return inTable(s, mulOps); }
bool isRelOp(string s){ return inTable(s, relOps); }

/* Get the list of scope local variable names */
string[] lvarList(ref Parser p){
  string[] ret;
  foreach(v; p.args){ ret ~= v.vname; }
  return ret;
}

/* Get the offset of a scope local variable by name */
string lvarOffset(ref Parser p, string name){
  foreach(v; p.args){
    if(name == v.vname) return(to!string(((p.args.length+1)*4) - v.voffset));
  } undefined(name); assert(0);
}

