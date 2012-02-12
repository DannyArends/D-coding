/**********************************************************************
 * \file src/io/events/keyevent.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.events.keyevent;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;

import core.typedefs.types;
import core.typedefs.basictypes;
import io.events.engine;

class KeyEvent : Event{
  this(SDL_keysym key, KeyEventType type, bool shift = false){
    this.key=key;
    this.type=type;
    this.shift=shift;
  }
  
  char getKeyPress(){
    char c;
    if((key.sym & 0xFF80) == 0 ){
      c = to!char(key.sym & 0x7F);
      if(shift) c = toShiftChar(c);
    }
    return c;
  }
  
  int getSDLkey(){ return key.sym; }
  KeyEventType getKeyEventType(){ return type; }
  EventType getEventType(){ return EventType.KEYBOARD;}
private:  
  SDL_keysym  key;
  KeyEventType type;
  bool         shift;
}
