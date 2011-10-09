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

enum Stage{LOADING, PLAYING, SHUTDOWN};

class ConceptEngine : EngineEventHandler{
  EngineEventHandler[]  handlers;
  EngineEvent[]         eventQueue;
  bool                  running;
  Stage                 stage = Stage.LOADING;
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
    ENG_Event payload = ENG_Event(ENG_Time(5000),&changeStage,EngineEventType.MOUSE,EngineEventType.PERIODIC);
    eventQueue ~= new EngineEvent(payload);
    mainLoop();
  }
 
  void mainLoop(){
    while(running){
      EngineEvent[] new_events;
      while(eventQueue.length > 0){
        EngineEvent e = eventQueue[0];
        if(e.type != EngineEventType.NULLEVENT){
          foreach(EngineEventHandler h; handlers){
            new_events ~= h.handle(e);
          }
        }
        eventQueue = eventQueue[1..$];
      }
      eventQueue ~= new_events;
      //Receive and pack SDL events;
      if(SDL_PollEvent(&event)){
        eventQueue ~= new EngineEvent(event);
      }
      //Get any events from the handlers
      foreach(EngineEventHandler h; handlers){
        eventQueue ~= h.update();
      }
      SDL_Delay(10);
      SDL_GL_SwapBuffers();
    }
  }
  
  EngineEvent[] handle(EngineEvent e){
    EngineEvent[] events;
    if(e.type==EngineEventType.SDLEVENT){
      SDL_Event sdl = e.sdl_event; 
      switch(sdl.type){         
        case SDL_QUIT:
          running = false;
        break;
        default:
        break;
      }
    }
    return events;
  }
  
  void shutDown(){
    //Clear eventQueue and deregister
    stage = Stage.SHUTDOWN;
  }
  
  void changeStage(int id,string data){
    writeln("After 5 seconds we're done with showing the logo");
    stage = Stage.PLAYING;
  }
}
