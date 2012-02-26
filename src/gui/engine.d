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
import std.conv;
import std.datetime;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import core.typedefs.types;

import sfx.engine;
import game.engine;
import game.users.gameclient;
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
    _sound = sound;
    _game = game;
    _screen = new Screen(this);
    _hud = new HudHandler(screen);
    _network = new GameClient(this);
    _game.startRendering(this);
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
            writeln("[GUI] QUIT received");
            if(game.gamestage == Stage.PLAYING) e = new QuitEvent();
            if(game.gamestage == Stage.MENU) rendering = false;
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
      switch(game.gamestage){
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
      }
      SDL_GL_SwapBuffers();
    }
    SDL_Quit();
    return;
  }
  
  void update(){
    super.update();
    game.update();
    sound.update();
    if((Clock.currTime() - getT0()).total!"msecs" >= 1000) {
      _fps.fps = _fps.cnt;
      _fps.cnt = 0;
      setT0();
    }else{ _fps.cnt++; }
  }

  @property int         frametime(){ return cast(int)(1000.0/screen_fps); }  
  @property string      fps(){ return to!string(_fps.fps); }
  @property int         width(int w = -1){ if(w > 0){ screen_width=w;} return screen_width; }
  @property int         height(int h = -1){ if(h > 0){ screen_height=h;} return screen_height; }
  @property HudHandler  hud(HudHandler h = null){ if(h !is null){ _hud=h;} return _hud; }
  @property GameEngine  game(GameEngine g = null){ if(g !is null){ _game=g; } return _game; }
  @property Screen      screen(Screen s = null){ if(s !is null){ _screen=s; } return _screen; }
  @property SFXEngine   sound(SFXEngine s = null){ if(s !is null){ _sound=s; } return _sound; }
  @property GameClient  network(GameClient g = null){ if(g !is null){ _network=g; } return _network; }
  
  void handle(Event e){
    if(game.gamestage == Stage.PLAYING){
      game.handle(e);
    }
  }
  
  private:
    int  videoFlags;
    bool rendering      = true;
    int  screen_width   = 900;
    int  screen_height  = 480;
    int  screen_bpp     = 32;
    int  screen_fps     = 30;
    HudHandler          _hud;
    FPS                 _fps;
    Screen              _screen;
    SFXEngine           _sound;
    GameEngine          _game;
    GameClient          _network;
    SDL_Surface*        surface;
    SDL_VideoInfo*      videoInfo;
}
