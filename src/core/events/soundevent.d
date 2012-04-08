/******************************************************************//**
 * \file src/core/events/soundevent.d
 * \brief Sound event definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.events.soundevent;

import std.array;
import std.stdio;

import core.typedefs.types;
import core.events.engine;

class SoundEvent : Event{
  this(string name){
    this.name=name;
  }

  string getSoundName(){ return name; }

  override EventType getEventType(){ return EventType.SOUND; }

private:  
  string name;
}
