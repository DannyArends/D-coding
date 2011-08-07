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
import gui.enginefunctions;

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
    eventhandler = new EventHandler(this);
    fpsmonitor = new FPSmonitor();
    writefln("Engine initialization done");
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
    resizeWindow(screen_width, screen_height);
    glTranslatef(-1.5f, 0.0f, -6.0f);

    glBegin( GL_TRIANGLES );             /* Drawing Using Triangles       */
      glColor3f(   1.0f,  0.0f,  0.0f ); /* Red                           */
      glVertex3f(  0.0f,  1.0f,  0.0f ); /* Top Of Triangle               */
      glColor3f(   0.0f,  1.0f,  0.0f ); /* Green                         */
      glVertex3f( -1.0f, -1.0f,  0.0f ); /* Left Of Triangle              */
      glColor3f(   0.0f,  0.0f,  1.0f ); /* Blue                          */
      glVertex3f(  1.0f, -1.0f,  0.0f ); /* Right Of Triangle             */
    glEnd( );                            /* Finished Drawing The Triangle */

    glLoadIdentity( );
    glTranslatef( 1.5f, 0.0f, -6.0f );
    glColor3f( 0.5f, 0.5f, 1.0f);
    glBegin( GL_QUADS );                 /* Draw A Quad              */
      glVertex3f(  1.0f,  1.0f,  0.0f ); /* Top Right Of The Quad    */
      glVertex3f( -1.0f,  1.0f,  0.0f ); /* Top Left Of The Quad     */
      glVertex3f( -1.0f, -1.0f,  0.0f ); /* Bottom Left Of The Quad  */
      glColor3f( 0.5f, 0.1f, 1.0f);
      glVertex3f(  1.0f, -1.0f,  0.0f ); /* Bottom Right Of The Quad */
    glEnd( );                            /* Done Drawing The Quad    */

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
  SDL_Surface*     surface;
  SDL_VideoInfo*   videoInfo;           /* This holds some info about our display */
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */
  bool done         = false;            /* Main loop variable */
  bool active       = true;             /* Is the window active? */
}
