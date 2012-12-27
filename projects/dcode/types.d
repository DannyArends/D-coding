/******************************************************************//**
 * \file src/core/typedefs/types.d
 * \brief Structure and type definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.types;

import std.stdio, std.file, std.conv, std.string, std.random;
import core.memory;

enum EventType { NULL, MOUSE, KEYBOARD, SOUND, GFX2D, GFX3D, CLOCK, NETWORK, QUIT }
enum NetEvent : char { UNKNOWN = 'U', HEARTBEAT = 'H', REGISTER = 'R', LOGIN = 'L', CHAT = 'C', MOVEMENT = 'M', GAME = 'G', OBJECT = 'O', SOUND = 'S', GFX2D = '2', GFX3D = '3'}
enum KeyEventType    { NONE, DOWN, UP  }
enum MouseBtn        { MOVE = 0, LEFT = 1, MIDDLE = 2, RIGHT = 3 }

struct Point{
  int x;
  int y;
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

/*
 * Transforms a character to its value when SHIFT is pressed
 * Based on US-101 keyboard
 */
char toShiftChar(char c){
  try{
    switch(to!int(to!string(c))){
      case 0:
        return ')';
      case 1:
        return '!';
      case 2:
        return '@';
      case 3:
        return '#';
      case 4:
        return '$';
      case 5:
        return '%';
      case 6:
        return '^';
      case 7:
        return '&';
      case 8:
        return '*';
      case 9:
        return '(';
      default: break;
    }
    return to!char(toUpper(to!string(c)));
  }catch{
    return to!char(toUpper(to!string(c)));
  }
}

