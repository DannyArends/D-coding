/**********************************************************************
 * \file src/gui/engine.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.engine;

import std.stdio;
import std.datetime;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import core.typedefs.types;

import sfx.engine;
import game.engine;
import io.events.engine;
import io.events.clockevents;
import io.events.mouseevent;
import io.events.keyevent;

import gui.enginefunctions;
import gui.screen;
import gui.hudhandler;

class GFXEngine : ClockEvents{
  
  this(GameEngine game, SFXEngine sound, bool verbose = false){
    if(SDL_Init(SDL_INIT_VIDEO) < 0){ writefln("Video initialization failed: %s", SDL_GetError()); return; }
    videoInfo = SDL_GetVideoInfo();
    if(videoInfo is null){ 
      writefln("Video initialization failed: %s", SDL_GetError()); 
      return;
    }
    
    videoFlags = initVideoFlags(videoInfo);
    SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
    surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags );
    if(surface is null){ 
      writefln("Video mode set failed: %s", SDL_GetError()); 
      return; 
    }
    SDL_WM_SetCaption("Game", "Danny Arends");
    initGL();
    this.sound = sound;
    this.game = game;
    this.screen = new Screen(this);
    this.hud = new HudHandler(screen);
    this.game.startRendering(this);
  }
  
  void start(bool verbose = false){
    setT0();
    printOpenGlInfo(verbose);
    add(new ClockEvent(&game.setMainMenuStage,8000));
    add(new ClockEvent(&game.rotateLogo,40,199,false));
    add(new ClockEvent(&game.changeLogo,2600,2,false));
    while(rendering){
      SysTime st = Clock.currTime();
      update();
      resizeWindow(screen_width, screen_height);
      Event     e;
      SDL_Event event;
      if(SDL_PollEvent(&event)){
        switch(event.type){
         case SDL_VIDEORESIZE:
            screen_width= event.resize.w;
            screen_height= event.resize.h;
            surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags);
            screen.resize(screen_width, screen_height);
            resizeWindow(screen_width, screen_height);
          break;        
          case SDL_QUIT:
            if(game.getGameStage()==Stage.PLAYING) e = new QuitEvent();
            if(game.getGameStage()==Stage.MENU) rendering = false;
          break;
          case SDL_MOUSEMOTION:
            handle(new MouseEvent(cast(MouseBtn)0, KeyEventType.NONE, event.button.x, event.button.y, event.motion.xrel, event.motion.yrel));
            if(verbose) writefln("Mouse moved by %d,%d to (%d,%d)", event.motion.xrel, event.motion.yrel, event.motion.x, event.motion.y);
          break;
          case SDL_MOUSEBUTTONDOWN:
            e = new MouseEvent(cast(MouseBtn)event.button.button,KeyEventType.DOWN, event.button.x, event.button.y);
            if(verbose) writefln("Mouse button %d pressed at (%d,%d)", event.button.button, event.button.x, event.button.y);
          break;
          case SDL_MOUSEBUTTONUP:
            e = new MouseEvent(cast(MouseBtn)event.button.button,KeyEventType.UP, event.button.x, event.button.y);
            if(verbose) writefln("Mouse button %d pressed at (%d,%d)", event.button.button, event.button.x, event.button.y);
          break;
          case SDL_KEYDOWN:
            e = new KeyEvent(event.key.keysym, KeyEventType.DOWN);
            if(verbose) writefln("Key down");
          break;
          case SDL_KEYUP:
            e = new KeyEvent(event.key.keysym, KeyEventType.UP);
            if(verbose) writefln("Key up");
          break;
          default:
          break;
        }
      }
      SysTime sr3d = Clock.currTime();
      screen.render3D();
      long dr3d = (Clock.currTime() - sr3d).total!"msecs";
      switch(game.getGameStage()){
        case Stage.PLAYING:
          game.render();
          game.handle(e);    
        break;
        case Stage.MENU:
          hud.handle(e);
        break;
        default:
        break;
      }
      screen.render();
      long rt = (Clock.currTime() - st).total!"msecs";
      if(rt < frametime){
        SDL_Delay(cast(int)(frametime-rt));
      }else{
        writefln("[GFX] Warning framerate (%s) %s",frametime-rt,dr3d);
      }
      SDL_GL_SwapBuffers();
    }
  }
  
  void update(){
    super.update();
    game.update();
    sound.update();
    if((Clock.currTime() - getT0()).total!"msecs" >= 1000) {
      fps.fps = fps.cnt;
      fps.cnt = 0;
      setT0();
    }else{ fps.cnt++; }
  }
  
  int getWidth(){ return screen_width; }
  int getHeight(){ return screen_height; }
  int getFPS(){ return fps.fps; }
  
  GameEngine getGameEngine(){  return game; }
  Screen getScreen(){  return screen; }
  SFXEngine getSound(){  return sound; }
  
  void handle(Event e){
    if(game.getGameStage()==Stage.PLAYING){
      game.handle(e);
    }
  }
  
  @property int frametime(){ return cast(int)(1000.0/screen_fps); }

  private:
    int  videoFlags;
    bool rendering      = true;
    int  screen_width   = 900;
    int  screen_height  = 480;
    int  screen_bpp     = 32;
    int  screen_fps     = 25;
    HudHandler          hud;
    FPS                 fps;
    Screen              screen;
    SFXEngine           sound;
    GameEngine          game;
    SDL_Surface*        surface;
    SDL_VideoInfo*      videoInfo;
}
