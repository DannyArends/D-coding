/**********************************************************************
 * \file src/gui/enginefunctions.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.enginefunctions;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.glu;

bool resizeWindow(int width, int height){
  if(height == 0) height = 1;
  GLfloat ratio = cast(GLfloat)height / cast(GLfloat)width;
  glViewport(0, 0, cast(GLsizei)width, cast(GLsizei)height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-1.0, 1.0, -ratio, ratio, 1.0, 1000.0);
  glMatrixMode(GL_MODELVIEW);
  glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
  glEnable(GL_DEPTH_TEST);
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

GLdouble[3] getUnproject(int x, int y){
  GLint viewport[4];
  GLdouble modelview[16];
  GLdouble projection[16];
  GLfloat  winZ;
  
  GLdouble pos[3];

  glGetDoublev(GL_MODELVIEW_MATRIX, modelview.ptr);
  glGetDoublev(GL_PROJECTION_MATRIX, projection.ptr);
  glGetIntegerv(GL_VIEWPORT, viewport.ptr);

  GLfloat winX = x;
  GLfloat winY = viewport[3] - y;
  glReadPixels(x, cast(int)winY, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &winZ );
  gluUnProject( winX, winY, winZ, modelview.ptr, projection.ptr, viewport.ptr, &pos[0], &pos[1], &pos[2]);
  writefln("World location: [%s, %s, %s]",to!string(pos[0]), to!string(pos[1]), to!string(pos[2]));
  return pos;
}

void printOpenGlInfo(bool verbose = false){
  if(verbose){
    writefln("[GFX] Renderer = %s", to!string(glGetString(GL_RENDERER)));
    writefln("[GFX] OpenGL   = %s", to!string(glGetString(GL_VERSION)));
    writefln("[GFX] Vendor   = %s", to!string(glGetString(GL_VENDOR)));
  }
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

class FPSmonitor{
  void update(){
    Frames++;
    t = SDL_GetTicks();
    if (t - T0 >= 5000) {
      GLfloat seconds = (t - T0) / 1000.0;
      GLfloat fps = Frames / seconds;
      printf("%d frames in %g seconds = %g FPS\n", Frames, seconds, fps);
      T0 = t;
      Frames = 0;
    }
  }
  GLint t           = 0;               /* t */
  GLint T0          = 0;               /* T0 for famerate determination */
  GLint Frames      = 0;               /* Number of frames rendered */
}
