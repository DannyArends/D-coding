/**********************************************************************
 * \file src/core/typedefs/basictypes.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.basictypes;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import core.memory;

/*
 * Splits a string by sep, and transforms each element to types of T
 */
T[] stringToArray(T)(string s, string sep= ","){
  string[] entities = s.split(sep);
  T[] marray;
  foreach(string e;entities){
    marray ~= to!T(e);
  }
  return marray;
}

struct Point {
  int x;
  int y;
}

struct Size {
  int width;
  int height;
}
