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
  void handleEngineEvent(EngineEvent e){
    if(e.type==EngineEventType.SDLEVENT){
      switch(e.event.type){         
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
  }

  EngineEvent getEngineEvent(){ return new EngineEvent(); }
}
