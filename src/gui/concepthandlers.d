module gui.concepthandlers;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import core.typedefs.eventhandling;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.gl_1_5;
import gl.gl_ext;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import gui.enginefunctions;

enum EngineEventType {NULLEVENT, SDLEVENT, ENGINE, SCREEN, HUD, KEY, MOUSE };

class EngineEvent{
  string          name;
  string          descr;
  EngineEventType type;
  SDL_Event       event;
  
  this(string name= "Null",string descr="Ignored",EngineEventType type = EngineEventType.NULLEVENT){
    this.name = name;
    this.descr = descr;
    this.type = type;
  }
  
  this(SDL_Event event){
    this("SDL","SDL Wrap",EngineEventType.SDLEVENT);
    this.event = event;
  }
}

interface EngineEventHandler{
  abstract void handleEngineEvent(EngineEvent e);
  abstract EngineEvent getEngineEvent();
}
