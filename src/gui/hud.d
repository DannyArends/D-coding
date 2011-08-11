module gui.hud;

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

import gui.engine;
import gui.formats.tga;
import gui.widgets.object2d;

class Hud{
public:
  this(Engine engine){
    this.parent = engine;
    initfont();
  }
  
  void addObject(Object2D object){
    objects ~= object;
  }
  
  void initfont(){
    tgaInfo* t = loadTexture("data/textures/font.tga");
    textureid = t.textureID[0];
    base = loadAsFont(t);
  }
  
  void render(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, cast(GLfloat)parent.screen_width,cast(GLfloat)parent.screen_height, 0.0f, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    foreach(Object2D object;objects){
      object.render();
    }
  }
  
  GLuint getFontBase(){ return base; }
  GLuint getFontId(){ return textureid; }
  
private:
  Engine parent;
  Object2D[] objects;
  GLuint     textureid;
  GLuint     base;
}