/**********************************************************************
 * \file src/main/ostest.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.array, std.stdio, std.conv;
import core.executor;

void main(string[] args){
  ExecEnvironment e = new ExecEnvironment();
  e.detectEnvironment();
  writeln(e);
}