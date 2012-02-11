
import std.array;
import std.stdio;
import std.conv;

import core.interpreters.p;

void main(string[] args){
  string input = "";
  if(args.length >= 3){
    for(int a=2; a < args.length; a++){
      if(a > 2) input ~= " ";
      input ~= args[a];
    }
  }
  if(args.length < 2){
    writeln("-- P'' language interpreter --\n\nUse: plang <program> <input>\nP'' operators: R l ( )\n(c) Danny Arends 2011");
  }else{
    auto p = new PInterpreter(args[1],input);
    p.run();
  }
}