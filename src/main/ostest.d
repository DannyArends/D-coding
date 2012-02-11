
import std.array;
import std.stdio;
import std.conv;

import core.io.executor;

void main(string[] args){
  ExecEnvironment e = new ExecEnvironment();
  e.detectEnvironment();
  writeln(e);
}