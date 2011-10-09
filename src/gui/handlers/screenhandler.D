module gui.handlers.screenhandler;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import core.typedefs.eventhandling;
import gui.enginefunctions;
import gui.concepthandlers;

class ScreenHandler : EngineEventHandler{
  int screen_width  = 800;
  int screen_height = 600;
  int screen_bpp    = 32;
  SDL_Surface*        surface;
  SDL_VideoInfo*      videoInfo;        /* This holds some info about our display */
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */

  
  this(){
    if(SDL_Init(SDL_INIT_VIDEO) < 0){ writefln("Video initialization failed: %s", SDL_GetError()); return; }
    videoInfo = SDL_GetVideoInfo();
    if(videoInfo is null){ writefln("Video initialization failed: %s", SDL_GetError()); return; }
    videoFlags = initVideoFlags(videoInfo);
    SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );

    surface = SDL_SetVideoMode( screen_width, screen_height, screen_bpp, videoFlags );
    if(surface is null){ writefln("Video mode set failed: %s", SDL_GetError()); return; }
    SDL_WM_SetCaption("SDL OpenGL using D", "Danny Arends");
    initGL();
    printOpenGlInfo();
    resizeWindow(screen_width, screen_height);
  }

  void handleEngineEvent(EngineEvent e){
    // Nothing here yet
    if(e.type==EngineEventType.SDLEVENT){
      switch(e.event.type){         
        case SDL_VIDEORESIZE:
          screen_width= e.event.resize.w;
          screen_height= e.event.resize.h;
          surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags);
          resizeWindow(screen_width, screen_height);
        break;
        default:
        break;
      }
    }
  }

  EngineEvent getEngineEvent(){
    resizeWindow(screen_width, screen_height);
    // Nothing here yet
    return new EngineEvent();
  }
}
