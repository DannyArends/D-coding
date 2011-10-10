module gui.handlers.timehandler;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import core.typedefs.eventhandling;
import gui.concepthandlers;

class TimeHandler : EngineEventHandler{
  EngineEvent[] handle(EngineEvent e){
    EngineEvent[] events;
    if(e.type == EngineEventType.PERIODIC){
      monitored ~= e.eng_event;
    }
    return events;
  }
  
  EngineEvent update(){
    t = SDL_GetTicks();
    for(auto x = 0; x < monitored.length;x++){
      monitored[x].timedata.checks++;
      if(t - monitored[x].timedata.t0 >= monitored[x].timedata.period) {
        writeln("Executing: ", monitored[x].payload, " after ", monitored[x].timedata.checks);
        monitored[x].payload(monitored[x].timedata.checks,"check");
        monitored[x].timedata.t0 = t;
        monitored[x].timedata.checks = 0;
        if(monitored[x].timedata.remove){
          monitored = monitored[0..x] ~ monitored[x+1..$];
        }
      }
    }
    return new EngineEvent();
  }

private:  
  int t      = 0;               /* t for time determination */  
  ENG_Event[]  monitored;
}
