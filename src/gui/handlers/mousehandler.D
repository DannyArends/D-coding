module gui.handlers.mousehandler;

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

class MouseHandler : EngineEventHandler{
  
  void handleEngineEvent(EngineEvent e){
    if(e.type==EngineEventType.SDLEVENT){
      switch(e.event.type){         
        case SDL_MOUSEMOTION:
          writefln("Mouse moved by %d,%d to (%d,%d)", e.event.motion.xrel, e.event.motion.yrel, e.event.motion.x, e.event.motion.y);
        break;
        case SDL_MOUSEBUTTONDOWN:
        writefln("Mouse button %d pressed at (%d,%d)", e.event.button.button, e.event.button.x, e.event.button.y);
        break;
        default:
        break;
      }
    }
  }

  EngineEvent getEngineEvent(){
    // Nothing here yet
    return new EngineEvent();
  }
}
