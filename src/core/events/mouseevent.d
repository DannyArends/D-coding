/******************************************************************//**
 * \file src/core/events/mouseevent.d
 * \brief Mouse event definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.events.mouseevent;

import std.array;
import std.stdio;
import std.conv;

import core.typedefs.types;
import core.events.engine;

class MouseEvent : Event{
  alias double[3] function(int,int)LocToWorld;
  
  this(MouseBtn btn, KeyEventType type, LocToWorld fun, int[2] xy, int xr = 0, int yr = 0, bool verbose = true){
    this.btn=btn;
    this.type=type;
    coords[0]=xy[0];
    coords[1]=xy[1];
    coords[2]=xr;
    coords[3]=yr;
    unproject = fun;
  }
  
  double[3] getXYZ(){ return unproject(sx, sy); }
  EventType getEventType(){ return EventType.MOUSE; }
  MouseBtn getBtn(){ return btn; }
  KeyEventType getType(){ return type; }
  
  @property int sx(){ return coords[0]; }
  @property int sy(){ return coords[1]; }
  @property int sxr(){ return coords[2]; }
  @property int syr(){ return coords[3]; }

private:
  MouseBtn       btn;
  KeyEventType   type;
  LocToWorld     unproject;
  int            coords[4] = [0,0,0,0];
}
