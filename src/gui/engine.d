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

import gui.eventhandler;
import gui.hud;
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
import gui.widgets.window;

class Engine{
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
    hud = new Hud(this);
    eventhandler = new EventHandler(this);
    fpsmonitor = new FPSmonitor();
    camera = new Camera();
    Surface s = new Surface(0.0,-0.2,0);
    for(int x=0;x<10;x++){
      for(int y=0;y<10;y++){
        Triangle t = new Triangle();
        t.adjustSize(0.5);
        t.rotate(x,y*2,x*3);
        t.setColor(cast(float)(x)/10.0,cast(float)(y)/20.0,0);
        s.addObject(x+7,y*2,t);
      }
    }
    s.addObject(2,2,new Model3DS("data/objects/object_4.3ds"));
    objects ~= s;
    writefln("Engine initialization done");
    Window win = new Window(100,100,hud);  
    Text tex = new Text(0,0,"Test Text",win);
    tex.removeLine();
    tex.removeLine();
    tex.removeLine();
    tex.addLine("Hoi Hoi");
    tex.addLine("So So");
    win.addContent(tex);
    hud.addObject(win);
  }
  
  void start(){
    while(!done){
      if(active)drawGLScene();
      eventhandler.call();
      SDL_Delay(10);
    }
    writefln("Engine shutdown received.");
    SDL_Quit();
    writefln("Bye...");
  }
  
  int drawGLScene(){
    hud.render();
    resizeWindow(screen_width, screen_height);
    foreach(Object3D o; objects){
     o.render(camera, o.getFaceType());
    }
    /* Draw it to the screen */
    SDL_GL_SwapBuffers();
    fpsmonitor.update();
    return true;
  }
  
  bool isDone(){ return done; }
  bool isDone(bool d){ done = d; return done; }
  
  bool isActive(){ return active; }
  bool isActive(bool a){ active=a; return active; }
  
  int getVideoFlags(){ return videoFlags; }
  Camera getCamera(){ return camera; }
  SDL_Surface* getSurface(){ return surface; }

  void setSurface(int w, int h){
    active=false;
    screen_width=w;
    screen_height=h;
    surface = SDL_SetVideoMode(screen_width, screen_height, screen_bpp, videoFlags);
  }
    
  int screen_width  = 640;
  int screen_height = 480;
  int screen_bpp    = 16;
    
private:  
  EventHandler     eventhandler;
  FPSmonitor       fpsmonitor;
  Camera           camera;
  Hud              hud;
  Object3D[]       objects;
  SDL_Surface*     surface;
  SDL_VideoInfo*   videoInfo;           /* This holds some info about our display */
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */
  bool done         = false;            /* Main loop variable */
  bool active       = true;             /* Is the window active? */
}
