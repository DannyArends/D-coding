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
import gui.widgets.window;
import gui.widgets.textinput;

class Hud : Window{
public:
  this(Engine engine){
    super(0,0,engine.screen_width,engine.screen_height);
    this.parent = engine;
    initfont();
    hudtext = new TextInput(0,engine.screen_height-16,this);
  }
  
  void initfont(){
    tgaInfo* t = loadTexture("data/textures/font.tga");
    textureid = t.textureID[0];
    base = loadAsFont(t);
  }
  
  void render(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, cast(GLfloat)parent.screen_width,cast(GLfloat)parent.screen_height, 0.0f, 0.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glDisable(GL_DEPTH_TEST);
    foreach(Object2D object;getObjects()){
      object.render();
    }
    hudtext.render();
  }
  
  void resize(int width, int height){
    super.resize(width, height);
    hudtext.setLocation(0,height-16,0);
    hudtext.setSize(width,16);
  }
  
  bool isHud(){ return true; }
  TextInput getHudText(){ return hudtext; }
  Object2DType getType(){ return Object2DType.HUD; }
  GLuint getFontBase(){ return base; }
  GLuint getFontId(){ return textureid; }
  
private:
  Engine     parent;
  GLuint     textureid;
  GLuint     base;
  TextInput  hudtext;
}