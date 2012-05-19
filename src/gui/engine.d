/******************************************************************//**
 * \file src/gui/engine.d
 * \brief GFXEngine class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.engine;

import std.stdio, std.conv, std.datetime;
import sdl.sdl, sdl.sdlstructs, sdl.sdlfunctions;
import core.typedefs.types;
import sfx.engine;
import game.engine, game.users.gameclient;
import core.events.engine, core.events.clockevents;
import core.events.keyevent, core.events.mouseevent;
import core.events.networkevent;
import gui.enginefunctions, gui.screen, gui.hudhandler;

/*! \brief EventHandler for all GFX related events
 *
 *  The GFXEngine class is the main EventHandler for all GFX related events
 */
class GFXEngine : ClockEventHandler{
  public:
  this(GameEngine game, SFXEngine sound, bool verbose = false){
    if(SDL_Init(SDL_INIT_VIDEO) < 0){ writefln("Video initialization failed: %s", SDL_GetError()); return; }
    videoInfo = SDL_GetVideoInfo();
    if(videoInfo is null){ 
      writefln("Video initialization failed: %s", SDL_GetError()); 
      return;
    }
    
    videoFlags = initVideoFlags(videoInfo);
    writeln("[GFX] videoFlags done");
    SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );
    surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags );
    if(surface is null){ 
      writefln("Video mode set failed: %s", SDL_GetError()); 
      return; 
    }
    writeln("[GFX] surface done");
    SDL_WM_SetCaption("Game", "Danny Arends");
    initGL();
    writeln("[GFX] initGL done");
    _sound = sound;
    _game = game;
    _screen = new Screen(this);
    _hud = new HudHandler(this);
    _network = new GameClient(this,"localhost");
    _game.startRendering(this);
    writeln("[GFX] Constructor done");
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
            int[2] xy = [cast(int)event.button.x, cast(int)event.button.y];
            handle(new MouseEvent(cast(MouseBtn)0, KeyEventType.NONE, &getUnproject, xy, event.motion.xrel, event.motion.yrel));
            if(verbose) writefln("Mouse moved by %d,%d to (%d,%d)", event.motion.xrel, event.motion.yrel, xy);
          break;
          case SDL_MOUSEBUTTONDOWN:
            int[2] xy = [cast(int)event.button.x, cast(int)event.button.y];
            e = new MouseEvent(cast(MouseBtn)event.button.button,KeyEventType.DOWN, &getUnproject, xy);
            if(verbose) writefln("Mouse button %d pressed at (%d,%d)", event.button.button, xy);
          break;
          case SDL_MOUSEBUTTONUP:
            int[2] xy = [cast(int)event.button.x, cast(int)event.button.y];
            e = new MouseEvent(cast(MouseBtn)event.button.button,KeyEventType.UP, &getUnproject, xy);
            if(verbose) writefln("Mouse button %d pressed at (%d,%d)", event.button.button, xy);
          break;
          case SDL_KEYDOWN:
            e = new KeyEvent(event.key.keysym.sym, KeyEventType.DOWN);
            if(verbose) writefln("Key down");
          break;
          case SDL_KEYUP:
            e = new KeyEvent(event.key.keysym.sym, KeyEventType.UP);
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
  
  override void update(){
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
  
  override void handle(Event e){
    if(e.getEventType() == EventType.NETWORK){
      NetworkEvent n_evt = cast(NetworkEvent) e;
      if(network !is null){
        if(n_evt.incomming){
          //writeln("[ENG] NetEvent: " ~ n_evt.full);
        }else{
          network.send(n_evt.full);
        }
      }
    }
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

