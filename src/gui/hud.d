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
import gui.widgets.text;
import gui.widgets.textinput;

class Hud : Window{
public:
  this(Engine engine){
    super(0,0,engine.screen_width,engine.screen_height,null,false);
    this.parent = engine;
    initfont();
    hudtext = new TextInput(0,engine.screen_height-16,this);
    servertext =  new Text(0, 0,"",this);
    servertext.setMaxLines(5);
  }
  
  void initfont(){
    font_texture = loadTexture("data/textures/font.tga");
    textureid = font_texture.textureID[0];
    base = loadAsFont(font_texture);
  }
  
  void render(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, cast(GLfloat)parent.screen_width,cast(GLfloat)parent.screen_height, 0.0f, 0.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glDisable(GL_DEPTH_TEST);
    servertext.render();
    hudtext.render();
    foreach(Object2D object;getObjects()){
      object.render();
    }
    SDL_GL_SwapBuffers();
  }
  
  void resize(int width, int height){
    super.resize(width, height);
    initfont();
    setMySize(width,height);
    hudtext.setLocation(0,height-16,0);
    hudtext.setSize(width,16);
  }
  
  bool isHud(){ return true; }
  TextInput getHudText(){ return hudtext; }
  Text getServerText(){ return servertext; }
  Object2DType getType(){ return Object2DType.HUD; }
  GLuint getFontBase(){ return base; }
  Engine getEngine(){ return parent; }
  GLuint getFontId(){ return textureid; }
  
private:
  Engine     parent;
  GLuint     textureid;
  GLuint     base;
  tgaInfo    font_texture;
  Text       servertext;
  TextInput  hudtext;
}