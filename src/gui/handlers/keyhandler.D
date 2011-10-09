module gui.handlers.keyhandler;

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

class KeyHandler : EngineEventHandler{
  EngineEvent[] handle(EngineEvent e){
    EngineEvent[] events;
    if(e.type==EngineEventType.SDLEVENT){
      SDL_Event sdl = e.sdl_event; 
      switch(sdl.type){         
        case SDL_KEYDOWN:
          writefln("Key down");
        break;
        case SDL_KEYUP:
        writefln("Key up");
        break;
        default:
        break;
      }
    }
    return events;
  }
}
