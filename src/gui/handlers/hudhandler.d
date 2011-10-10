module gui.handlers.hudhandler;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.gl_1_5;
import gl.gl_ext;

import core.typedefs.eventhandling;
import gui.concepthandlers;
import gui.conceptloader;
import gui.formats.tga;

class HudHandler : EngineEventHandler{
  
  this(EngineLoader[] loaders){
    foreach(loader; loaders){
      if(loader.type==LoaderType.TEXTURE) textureloader = cast(TextureLoader) loader;
    }
  }
  
  EngineEvent[] handle(EngineEvent e){
    EngineEvent[] events;
    if(e.type==EngineEventType.SDLEVENT){
      SDL_Event sdl = e.sdl_event; 
      switch(sdl.type){         
        case SDL_VIDEORESIZE:
          screen_width= sdl.resize.w;
          screen_height= sdl.resize.h;
        break;
        default:
        break;
      }
    }
    return events;
  }
  
  EngineEvent update(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, cast(GLfloat)screen_width,cast(GLfloat)screen_height, 0.0f, 0.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glDisable(GL_DEPTH_TEST);
    return new EngineEvent();
  }
  
  private:
  int            screen_width  = 900;
  int            screen_height = 480;
  TextureLoader  textureloader;
}
