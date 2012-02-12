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
 * Transforms a character to its value when SHIFT is pressed
 * Based on US-101 keyboard
 */
char toShiftChar(char c){
  try{
    switch(to!int(to!string(c))){
      case 0:
        return ')';
      break;
      case 1:
        return '!';
      break;
      case 2:
        return '@';
      break;
      case 3:
        return '#';
      break;      
      case 4:
        return '$';
      break;
      case 5:
        return '%';
      break;
      case 6:
        return '^';
      break;
      case 7:
        return '&';
      break;
      case 8:
        return '*';
      break;
      case 9:
        return '(';
      break;
      default:
      break;
    }
    return to!char(toUpper(to!string(c)));
  }catch{
    return to!char(toUpper(to!string(c)));
  }
}

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
