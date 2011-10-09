module gui.conceptengine;

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
import gui.handlers.hudhandler;
import gui.handlers.keyhandler;
import gui.handlers.screenhandler;
import gui.handlers.timehandler;
import gui.handlers.mousehandler;
import gui.enginefunctions;

class ConceptEngine : EngineEventHandler{
  EngineEventHandler[]  handlers;
  EngineEvent[]         eventQueue;
  bool                  running;
  SDL_Event             event;                    /* Used to collect events */
  
  this(){
    running = true;
  }
  
  void start(){
    //Register handlers, and start then up
    handlers ~= this;
    handlers ~= new ScreenHandler();
    handlers ~= new KeyHandler();
    handlers ~= new MouseHandler();
    handlers ~= new HudHandler();
    handlers ~= new TimeHandler();
    mainLoop();
  }
 
  void mainLoop(){
    while(running){
      while(eventQueue.length > 0){
        EngineEvent e = eventQueue[0];
        foreach(EngineEventHandler h; handlers){
          h.handleEngineEvent(e);          
        }
        eventQueue = eventQueue[1..$];
      }
      //Receive and pack SDL events;
      if(SDL_PollEvent(&event)){
        eventQueue ~= new EngineEvent(event);
      }
      //Get any events from the handlers
      foreach(EngineEventHandler h; handlers){
        eventQueue ~= h.getEngineEvent();
      }
      SDL_Delay(10);
      SDL_GL_SwapBuffers();
    }
  }
  
  void handleEngineEvent(EngineEvent e){
    // Nothing here yet
    if(e.type==EngineEventType.SDLEVENT){
      switch(e.event.type){         
        case SDL_QUIT:
          running = false;
        break;
        default:
        break;
      }
    }
  }
  
  EngineEvent getEngineEvent(){ return new EngineEvent(); }
 
  void shutDown(){
    //Clear eventQueue and deregister
  }
}
