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
  
  EngineEvent[] handle(EngineEvent e){
    EngineEvent[] events;
    if(e.type==EngineEventType.SDLEVENT){
      SDL_Event sdl = e.sdl_event; 
      switch(sdl.type){         
        case SDL_MOUSEMOTION:
          writefln("Mouse moved by %d,%d to (%d,%d)", sdl.motion.xrel, sdl.motion.yrel, sdl.motion.x, sdl.motion.y);
        break;
        case SDL_MOUSEBUTTONDOWN:
          //Add an periodic event for the TimeHandler
          //ENG_Event payload = ENG_Event(ENG_Time(5000),&sayHello,EngineEventType.MOUSE,EngineEventType.PERIODIC);
          //events ~= new EngineEvent(payload);
          writefln("Mouse button %d pressed at (%d,%d)", sdl.button.button, sdl.button.x, sdl.button.y);
        break;
        default:
        break;
      }
    }
    return events;
  }
  
  void sayHello(int id,string data){
    writeln(to!string(id) ~ ":" ~ data);
  }
}
