module gui.handlers.hudhandler;

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

class HudHandler : EngineEventHandler{
  void handleEngineEvent(EngineEvent e){
    // Nothing here yet
  }

  EngineEvent getEngineEvent(){
    // Nothing here yet
    return new EngineEvent();
  }

}
