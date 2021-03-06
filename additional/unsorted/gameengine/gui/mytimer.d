/******************************************************************//**
 * \file src/gui/mytimer.d
 * \brief Definitions of TimedEvent and MyTimer
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.mytimer;

import std.array, std.stdio, std.conv;
import sdl.sdlfunctions;
import gl.gl_1_0;

alias void delegate(int) TimeFunc;

struct TimedEvent{
  this(TimeFunc toexecute, int period = 1000){
    this.period = period;
    this.toexecute = toexecute;
  }
  int period = 1000;         /* 1 second */
  TimeFunc toexecute;          /* what do we execute */
  int checks = 0;            /* Number of times we check */
  int t0     = 0;            /* T0 for time determination */
}

class MyTimer{
  void update(){
    t = SDL_GetTicks();
    for(auto x = 0; x < monitored.length;x++){
      monitored[x].checks++;
      if(t - monitored[x].t0 >= monitored[x].period) {
        writeln("Executing ", monitored[x].toexecute, " after ", monitored[x].checks);
        monitored[x].toexecute(monitored[x].checks);
        monitored[x].t0 = t;
        monitored[x].checks = 0;
      }
    }
  }
  
  void addTimedEvent(TimedEvent t){
    monitored ~= t;
  }
private:  
  GLint t      = 0;               /* t for time determination */  
  TimedEvent[] monitored;
}
