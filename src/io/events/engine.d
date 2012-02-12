/**********************************************************************
 * \file src/io/events/keyevent.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.events.engine;

import std.stdio;
import std.conv;

import core.typedefs.types;
import core.typedefs.basictypes;
import sdl.sdlfunctions;
import sdl.sdlstructs;

enum EventType{MOUSE, KEYBOARD, SOUND, GFX2D, GFX3D, CLOCK, QUIT}
enum KeyEventType{UP, DOWN, NONE}
enum MouseBtn{MOVE=0, LEFT=1, MIDDLE=2, RIGHT=3}

class Event{
  abstract EventType getEventType();
  
  int  getAge(){ return (SDL_GetTicks()-t0); }
  void resetAge(){ t0 = SDL_GetTicks(); }
  
  bool      verbose = true;
  bool      handled = false;
  int       t0      = 0;
}

class QuitEvent : Event{
  EventType getEventType(){
    return EventType.QUIT;
  }
}

abstract class EventHandler{
  public:
    void add(Event t){
      if(t !is null){
        eventqueue ~= t;
      }
    }
    
    void clean(){
      Event[] evtqueue;
      foreach(Event e;eventqueue){
        if(!e.handled) evtqueue ~= e;
      }
      eventqueue=evtqueue;
    }
    
    abstract void handle(Event e);
    
    void update(){
      clean();
    }
  
  protected:
    Event[] eventqueue;
}
