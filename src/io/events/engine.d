/******************************************************************//**
 * \file src/io/events/engine.d
 * \brief Event and EventHandler
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.events.engine;

import std.stdio;
import std.conv;
import std.datetime;

import core.typedefs.types;

class Event{
  EventType getEventType(){ return EventType.NULL; }
  
  long getAge(){ return ((Clock.currTime()-t0).total!"msecs"); }
  void resetAge(){ t0 = Clock.currTime(); }
  
  bool      verbose = true;
  bool      handled = false;
  SysTime   t0;
}

class NetworkEvent : Event{
  this(string msg, bool incomming = true){
    _incomming=incomming;
    _msg=msg[1..($-1)];
    switch(msg[0]){
      case 'H':
        _evt=NetEvent.HEARTBEAT;
      break;
      case 'R':
        _evt=NetEvent.REGISTER;
      break;
      case 'L':
        _evt=NetEvent.LOGIN;
      break;
      case 'C':
        _evt=NetEvent.CHAT;
      break;
      case 'M':
        _evt=NetEvent.MOVEMENT;
      break;
      case 'G':
        _evt=NetEvent.GAME;
      break;
      default:
        _evt=NetEvent.UNKNOWN;
      break;
    }
  }
  
  EventType getEventType(){ return EventType.NETWORK; }
  NetEvent  getNetEvent(){ return _evt; }
  
  @property string    msg(){ return _msg; }
  @property bool      incomming(){ return _incomming; }
  @property string    full(){ return (_evt ~ _msg ~ "\0"); }
  
  private:
    bool     _incomming;
    string   _msg;
    NetEvent _evt;
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
