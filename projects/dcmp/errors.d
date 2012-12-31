module dcmp.errors;

import std.stdio, std.c.stdlib, std.string;

void error(string s){
  writeln();
  writefln("-Error: %s\n", s);
}

void abort(string s){
  error(s);
  exit(-1);
}

void expected(string s, string o){
  abort(format("'%s' expected, but found: '%s'", s, o));
}

void undefined(string name){
  abort(format("Undefined Identifier: %s", name));
}

void duplicate(string name){
  abort(format("Duplicate Identifier: %s", name));
}

