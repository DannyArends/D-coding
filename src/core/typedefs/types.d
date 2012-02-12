/**********************************************************************
 * \file src/core/typedefs/types.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.types;

import std.stdio;
import std.conv;
import std.string;
import std.random;
import core.memory;

T[] stringArrayToType(T)(string[] entities){
  T[] rowleveldata;
  for(auto e=0;e < entities.length; e++){
    rowleveldata ~= to!T(entities[e]);
  }
  return rowleveldata;
}

/*
 * Splits a string by sep, and transforms each element to types of T
 */
T[] stringToArray(T)(string s, string sep= ","){
  string[] entities = s.split(sep);
  return stringArrayToType!T(entities);
}

struct Point{
  int x;
  int y;
  
  this(int x, int y){
    this.x=x;
    this.y=y;
  }
}

struct Size {
  int width;
  int height;
}


struct Bone{
  float   length;
  string  name;
  bool    rotates = false;
  float   ori[4];
  string  objectname;
  Bone[]  bones;
}

struct Figure{
  string name;
  Bone root;
}

struct FPS{
  int   cnt = 0;
  int   fps = 0;
}

enum FileStatus{ 
  NO_SUCH_FILE = -6, 
  FILE_OPEN = -5, 
  READING_FILE = -4, 
  INDEXED_COLOR = -3, 
  MEMORY = -2, 
  COMPRESSED_FILE = -1, 
  OK = 0
}

struct Texture{
  string       name;
  FileStatus   status;
  uint[]       id;
  uint         type;
  uint         width,height,bpp;
  ubyte[]      data;
}

T[] toType(T)(ubyte[] buffer){
  T[] returnbuffer;
  foreach(int i, byte b ; buffer){
    returnbuffer ~= to!T(b);
  }
  return returnbuffer;
}

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
