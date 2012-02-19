/**********************************************************************
 * \file src/io/events/mouseevent.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.events.mouseevent;

import std.array;
import std.stdio;
import std.conv;

import io.events.engine;
import gui.enginefunctions;

class MouseEvent : Event{
  this(MouseBtn btn, KeyEventType type, int x, int y, int xr = 0, int yr = 0, bool verbose = true){
    this.btn=btn;
    this.type=type;
    coords[0]=x;
    coords[1]=y;
    coords[2]=xr;
    coords[3]=yr;
  }
  
  double[3] getXYZ(){ return getUnproject(sx, sy); }
  EventType getEventType(){ return EventType.MOUSE; }
  MouseBtn getBtn(){ return btn; }
  KeyEventType getType(){ return type; }
  
  @property int sx(){ return coords[0]; }
  @property int sy(){ return coords[1]; }
  @property int sxr(){ return coords[2]; }
  @property int syr(){ return coords[3]; }
  @property double wx(){ return getUnproject(sx, sy)[0]; }
  @property double wy(){ return getUnproject(sx, sy)[1]; }
  @property double wz(){ return getUnproject(sx, sy)[2]; }
private:
  MouseBtn     btn;
  KeyEventType type;
  int          coords[4] = [0,0,0,0];
}
