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
import gui.conceptloader;
import gui.formats.tga;

import gui.objects.box;
import gui.objects.camera;
import gui.objects.line;
import gui.objects.model3ds;
import gui.objects.object3d;
import gui.objects.quad;
import gui.objects.sphere;
import gui.objects.surface;
import gui.objects.triangle;

class ScreenHandler : EngineEventHandler{  
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
    
    camera = new Camera();
    textureloader = new TextureLoader();
    textureloader.load();
    Quad q = new Quad(0.1,-0.2,0);
    q.setTexture(textureloader.getTextureID("DGE"));
    q.setSize(2.0, 1.0, 1.0);
    objects ~= q;
    Surface s = new Surface(-32,-2,-32,textureloader.getTexture("Grass_1"));
    objects ~= s;
    resizeWindow(screen_width, screen_height);
  }
  
  EngineLoader[] getLoaders(){
    EngineLoader[] loaders;
    loaders ~= textureloader;
    return loaders;
  }

  EngineEvent[] handle(EngineEvent e){
    EngineEvent[] events;
    if(e.type==EngineEventType.SDLEVENT){
      SDL_Event sdl = e.sdl_event; 
      switch(sdl.type){         
        case SDL_VIDEORESIZE:
          screen_width= sdl.resize.w;
          screen_height= sdl.resize.h;
          surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags);
          textureloader.refreshAfterResize();
          resizeWindow(screen_width, screen_height);
        break;
        default:
        break;
      }
    }
    return events;
  }

  EngineEvent update(){
    resizeWindow(screen_width, screen_height);
    foreach(Object3D o; objects){
     o.render(camera, o.getFaceType());
    }
    return new EngineEvent();
  }
  
  int screen_width  = 900;
  int screen_height = 480;
  int screen_bpp    = 32;
  SDL_Surface*        surface;
  SDL_VideoInfo*      videoInfo;        /* This holds some info about our display */
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */
  Object3D[]          objects;
  TextureLoader       textureloader;
  Camera              camera;
}
