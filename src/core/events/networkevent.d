/*******************************************************************//**
 * \file src/core/events/networkevent.d
 * \brief Network event definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.events.networkevent;

import std.array;
import std.stdio;
import std.conv;

import core.typedefs.types;
import core.events.engine;

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
      case '2':
        _evt=NetEvent.GFX2D;
      break;
      case '3':
        _evt=NetEvent.GFX3D;
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
