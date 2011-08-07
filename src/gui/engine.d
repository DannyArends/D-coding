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

bool resizeWindow(int width, int height){
  if(height == 0) height = 1;
  GLfloat ratio = cast(GLfloat)height / cast(GLfloat)width;
  glViewport(0, 0, cast(GLsizei)width, cast(GLsizei)height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-1.0, 1.0, -ratio, ratio, 1.0, 1000.0);
  glMatrixMode(GL_MODELVIEW);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
  glLoadIdentity();
  return true;
}

bool initGL(){
  glShadeModel(GL_SMOOTH);
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  glClearDepth(1.0f);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  return true;
}

void printOpenGlInfo(){
  writefln("Renderer = %s", to!string(glGetString(GL_RENDERER)));
  writefln("OpenGL   = %s", to!string(glGetString(GL_VERSION)));
  writefln("Vendor   = %s", to!string(glGetString(GL_VENDOR)));
}

int initVideoFlags(SDL_VideoInfo* videoInfo){
  int videoFlags  = SDL_OPENGL;      /* Enable OpenGL in SDL */
  videoFlags |= SDL_GL_DOUBLEBUFFER; /* Enable double buffering */
  videoFlags |= SDL_HWPALETTE;       /* Store the palette in hardware */
  videoFlags |= SDL_RESIZABLE;       /* Enable window resizing */

  if(videoInfo.hw_available){
    writefln("Video info reports hardware surface available");
    videoFlags |= SDL_HWSURFACE;
  }else{
    writefln("Video info fallback to software surface");
    videoFlags |= SDL_SWSURFACE;
  }
  
  if(videoInfo.blit_hw){
    writefln("Video info reports hardware acceleration available");
    videoFlags |= SDL_HWACCEL;
  }
  return videoFlags;
}

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
    writefln("Engine initialization done");
    eventhandler = new EventHandler(this);
  }
  
  void start(){
    eventhandler.start();
    writefln("Eventhandler started in new thread.");
    while(!done){
      if(active)drawGLScene();
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
    SDL_GL_SwapBuffers( );
    Frames++;
    GLint t = SDL_GetTicks();
    if (t - T0 >= 5000) {
      GLfloat seconds = (t - T0) / 1000.0;
      GLfloat fps = Frames / seconds;
      printf("%d frames in %g seconds = %g FPS\n", Frames, seconds, fps);
      T0 = t;
      Frames = 0;
    }
    return true;
  }
  
  bool isDone(){ return done; }
  bool isDone(bool d){ done = d; return done; }
  
  int getVideoFlags(){
    return videoFlags;
  }
  
  bool isActive(){ return active; }
  bool isActive(bool a){ active=a; return active; }

  void setSurface(int w, int h, SDL_Surface* s){
    screen_width=w;
    screen_width=h;
    surface = s;
  }
  
  SDL_Surface* getSurface(){
    return surface;
  }
  
  int screen_width  = 640;
  int screen_height = 480;
  int screen_bpp    = 16;
    
private:  
  EventHandler     eventhandler;
  SDL_Surface*     surface;
  SDL_VideoInfo*   videoInfo;           /* This holds some info about our display */
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */
  GLint T0          = 0;                /* T0 for fmaerate determination */
  GLint Frames      = 0;                /* Number of frames rendered */
  bool done         = false;            /* Main loop variable */
  bool active       = true;             /* Is the window active? */
}
