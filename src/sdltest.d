
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

SDL_Surface *surface;
GLint T0     = 0;
GLint Frames = 0;
int SCREEN_WIDTH  = 640;
int SCREEN_HEIGHT = 480;
int SCREEN_BPP    =  16;

bool initGL(){
  glShadeModel(GL_SMOOTH);
  glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
  glClearDepth(1.0f);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  return true;
}

bool resizeWindow(int width, int height){
  if(height == 0) height = 1;
  GLfloat ratio = cast(GLfloat)width / cast(GLfloat)height;
  GLfloat inv_ratio = cast(GLfloat)height / cast(GLfloat)width;
  glViewport(0, 0, cast(GLsizei)width, cast(GLsizei)height);
  glMatrixMode(GL_PROJECTION );
  glLoadIdentity();
  glFrustum(-1.0, 1.0, -inv_ratio, inv_ratio, 1.0, 1000.0);
  //gluPerspective(45.0f, ratio, 0.1f, 100.0f);
  glMatrixMode(GL_MODELVIEW);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
  glLoadIdentity();
  return true;
}

void handleKeyPress( SDL_keysym *keysym ){
  switch(keysym.sym){
  case SDLK_ESCAPE:
    break;
    case SDLK_F1:
    SDL_WM_ToggleFullScreen(surface);
    break;
    default:
    break;
  }
}

int drawGLScene(){
  resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
  
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

void printOpenGlInfo(){
  writefln("Renderer = %s", to!string(glGetString(GL_RENDERER)));
  writefln("OpenGL   = %s", to!string(glGetString(GL_VERSION)));
  writefln("Vendor   = %s", to!string(glGetString(GL_VENDOR)));
}


void main(string[] args){
  int videoFlags;                       /* Flags to pass to SDL_SetVideoMode */
  bool done = false;                    /* main loop variable */
  SDL_Event event;                      /* used to collect events */
  SDL_VideoInfo* videoInfo;             /* this holds some info about our display */
  bool isActive = true;                 /* whether or not the window is active */
  
  writeln("Starting in Main");
  if(SDL_Init(SDL_INIT_VIDEO) < 0){
    writefln("Video initialization failed: %s", SDL_GetError());
    return;
  }
  videoInfo = SDL_GetVideoInfo();
  if(videoInfo is null){
    writefln("Video initialization failed: %s", SDL_GetError());
    return;
  }

  videoFlags  = SDL_OPENGL;          /* Enable OpenGL in SDL */
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
  SDL_GL_SetAttribute( SDL_GL_DOUBLEBUFFER, 1 );

  surface = SDL_SetVideoMode( SCREEN_WIDTH, SCREEN_HEIGHT, SCREEN_BPP, videoFlags );
  if(surface is null){
    writefln("Video mode set failed: %s", SDL_GetError());
    return;
  }
  SDL_WM_SetCaption("SDL OpenGL using D", "Danny Arends");
  initGL();
  printOpenGlInfo();
  resizeWindow(SCREEN_WIDTH, SCREEN_HEIGHT);
  writefln("GL done and resized");
  while(!done){
    if(isActive) drawGLScene();
    
    while(SDL_PollEvent(&event)){
      switch(event.type){
      case SDL_ACTIVEEVENT:
        if(event.active.gain == 0){
          isActive = false;
        }else{
          isActive = true;
        }
        break;          
      case SDL_VIDEORESIZE:
        surface = SDL_SetVideoMode( event.resize.w, event.resize.h, 16, videoFlags );
        if(surface is null){
          writefln("Video surface resize failed: %s", SDL_GetError());
          return;
        }
        resizeWindow( event.resize.w, event.resize.h );
        break;
      case SDL_KEYDOWN:
        handleKeyPress( &event.key.keysym );
        break;
      case SDL_QUIT:
        done = true;
        break;
      default:
        break;
      }
    }
    SDL_Delay(10);
  }
  writefln("Quiting...");
  SDL_Quit();
  writefln("Bye...");
}