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

import std.array, std.stdio, std.conv;
import core.typedefs.types;
import core.events.engine;

class NetworkEvent : Event{
  this(string msg, bool incomming = true){
    if(msg[($-1)]=='\0') msg = msg[0..($-1)];
    _incomming=incomming;
    _msg=msg[1..$];
    _evt=cast(NetEvent) msg[0];
  }
  
  override EventType getEventType(){ return EventType.NETWORK; }
  NetEvent  getNetEvent(){ return _evt; }
  
  @property string    msg(){ return _msg; }
  @property bool      incomming(){ return _incomming; }
  @property string    full(){ return (_evt ~ _msg ~ "\0"); }
  
  private:
    bool     _incomming;
    string   _msg;
    NetEvent _evt;
}
