/******************************************************************//**
 * \file src/core/events/engine.d
 * \brief Event and EventHandler
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.events.engine;

import std.stdio, std.conv, std.datetime;
import core.typedefs.types;

class Event{
  EventType getEventType(){ return EventType.NULL; }
  
  long getAge(){ return ((Clock.currTime()-t0).total!"msecs"); }
  void resetAge(){ t0 = Clock.currTime(); }
  
  bool      verbose = true;
  bool      handled = false;
  SysTime   t0;
}

class QuitEvent : Event{
  override EventType getEventType(){ return EventType.QUIT; }
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
