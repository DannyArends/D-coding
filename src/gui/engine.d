module gui.engine;

import core.thread;
import std.array;
import std.stdio;
import std.conv;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.gl_1_5;
import gl.gl_ext;

import core.typedefs.eventhandling;

import game.users.gameclient;

import gui.eventhandler;
import gui.hud;
import gui.scene;
import gui.mytimer;
import gui.enginefunctions;

import gui.objects.box;
import gui.objects.camera;
import gui.objects.line;
import gui.objects.model3ds;
import gui.objects.object3d;
import gui.objects.quad;
import gui.objects.sphere;
import gui.objects.surface;
import gui.objects.triangle;

import gui.widgets.text;
import gui.widgets.textinput;
import gui.widgets.slider;
import gui.widgets.window;
import gui.widgets.serverbutton;
import gui.widgets.windowbutton;

class Engine : EventHandler{
public:
  this(){
    writeln("Starting the Engine");
    if(SDL_Init(SDL_INIT_VIDEO) < 0){
      writefln("Video initialization failed: %s", SDL_GetError());
      return;
    }
    videoInfo = SDL_GetVideoInfo();
    if(videoInfo is null){
      writefln("Video initialization failed: %s", SDL_GetError());
      return;
    }
    videoFlags = initVideoFlags(videoInfo);
    SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );

    surface = SDL_SetVideoMode( screen_width, screen_height, screen_bpp, videoFlags );
    if(surface is null){
      writefln("Video mode set failed: %s", SDL_GetError());
      return;
    }
    SDL_WM_SetCaption("SDL OpenGL using D", "Danny Arends");
    initGL();
    printOpenGlInfo();
    resizeWindow(screen_width, screen_height);
    writefln("Initializing our own classes");
    
    mytimer = new MyTimer();
    camera = new Camera();
    fpsmonitor = new FPSmonitor();
    
    hud = new Hud(this);
    networkclient = new GameClient(this);
    
    eventhandler = new EngineEventHandler(this, hud, networkclient);
    scene = new Scene(this,camera);
    
    writefln("Engine initialization done");
  }
  
  void start(){
    networkclient.start();
    mytimer.addTimedEvent(TimedEvent(&networkclient.sendHeartbeat,5000));
    while(!done){
      drawGLScene();
      eventhandler.call();
      hud.render();
      SDL_Delay(10);
      mytimer.update();
    }
    networkclient.shutdown();
    writefln("Engine shutdown received.");
    SDL_Quit();
    writefln("Bye...");
  }
  
  int drawGLScene(){
    resizeWindow(screen_width, screen_height);
    scene.render();
    fpsmonitor.update();
    return true;
  }
  
  bool isDone(){ return done; }
  bool isDone(bool d){ done = d; return done; }
  
  @property bool active(){ return m_active; }
  @property bool active(bool a){ m_active=a; return m_active; }
  
  int getVideoFlags(){ return videoFlags; }
  Camera getCamera(){ return camera; }
  SDL_Surface* getSurface(){ return surface; }
  Hud getHud(){ return hud; }
  GameClient getNetwork(){ return networkclient; }
  void setNetwork(GameClient gc){ networkclient=gc; }
  
  void setSurface(int w, int h){
    active=false;
    screen_width=w;
    screen_height=h;
    surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags);
  }
  
  void handleNetworkEvent(string input){
    eventhandler.handleNetworkEvent(input);
  }
    
  int screen_width  = 800;
  int screen_height = 600;
  int screen_bpp    = 32;

private:  
  EngineEventHandler  eventhandler;
  MyTimer             mytimer;
  GameClient          networkclient;
  FPSmonitor          fpsmonitor;
  Camera              camera;
  Hud                 hud;
  Scene               scene;
  SDL_Surface*        surface;
  SDL_VideoInfo*      videoInfo;        /* This holds some info about our display */
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */
  bool done         = false;            /* Main loop variable */
  bool m_active     = true;             /* Is the window active? */
}
