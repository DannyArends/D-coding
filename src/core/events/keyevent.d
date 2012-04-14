/******************************************************************//**
 * \file src/core/events/keyevent.d
 * \brief Internal event dealing with keyboard input
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.events.keyevent;

import std.array;
import std.stdio;
import std.conv;

import core.typedefs.types;
import core.events.engine;

class KeyEvent : Event{
  this(int key, KeyEventType type, bool shift = false){
    this.key=key;
    this.type=type;
    this.shift=shift;
  }
  
  char getKeyPress(){
    char c;
    if((key & 0xFF80) == 0 ){
      c = to!char(key & 0x7F);
      if(shift) c = toShiftChar(c);
    }
    return c;
  }
  
  void setShift(bool status){ shift=status; }
  
  int getSDLkey(){ return key; }
  KeyEventType getKeyEventType(){ return type; }
  override EventType getEventType(){ return EventType.KEYBOARD;}
private:  
  int          key;
  KeyEventType type;
  bool         shift;
}
