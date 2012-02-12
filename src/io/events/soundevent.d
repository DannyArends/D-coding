/**********************************************************************
 * \file src/io/events/soundevent.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module events.soundevent;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;

import core.typedefs.types;
import io.events.engine;

class SoundEvent : Event{
  this(string name){
    this.name=name;
  }

  string getSoundName(){
    return name;
  }

  EventType getEventType(){
    return EventType.SOUND;
  }  

private:  
  string name;
}
