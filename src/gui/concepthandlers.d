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

enum EngineEventType {NULLEVENT, PERIODIC, SDLEVENT, ENGINE, SCREEN, HUD, KEY, MOUSE };
alias void delegate(int,string) EngineFunc;

struct ENG_Time{
  int             period;
  bool            remove     = true;
  int             checks     = 0;
  int             t0         = 0;
}

struct ENG_Event{
  ENG_Time        timedata;
  EngineFunc      payload;
  EngineEventType from;
  EngineEventType to;
}

class EngineEvent{
  string          name;
  string          descr;
  EngineEventType type;
  SDL_Event       sdl_event;
  ENG_Event       eng_event;
  
  this(string name= "Null",string descr="Ignored",EngineEventType type = EngineEventType.NULLEVENT){
    this.name = name;
    this.descr = descr;
    this.type = type;
  }
  
  this(SDL_Event event){
    this("SDL","SDL Wrap",EngineEventType.SDLEVENT);
    this.sdl_event = event;
  }
  
  this(ENG_Event event){
    this(to!string(event.from), to!string(event.from) ~ " to " ~to!string(event.to),event.to);
    this.eng_event = event;
  }
}

abstract class EngineEventHandler{
  abstract EngineEvent[] handle(EngineEvent e);
  EngineEvent update(){ return new EngineEvent(); }
}
