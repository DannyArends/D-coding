module gui.widgets.text;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.hud;
import gui.widgets.object2d;

class Text : Object2D{
public:
  this(Hud hud, double x, double y, string text){
    super(x,y,8*text.length,16);
    this.hud = hud;
    this.lines ~= text;
  }
  
  void render(){
    glLoadIdentity();
    glTranslatef(x(),y(),0.0f);
    glColor4f(r(), g(),  b(), alpha());
    foreach(int cnt, string line; lines){
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, hud.getFontId());
      glTranslated(cnt*16, 0.0f, 0.0f);
      glListBase(hud.getFontBase()-32+(128*type));
      glCallLists(to!int(line.length),GL_UNSIGNED_BYTE, line.dup.ptr);
      glDisable(GL_TEXTURE_2D);
    }
  }
  
private:
  Hud      hud;
  int      type=0;
  string[] lines;
}