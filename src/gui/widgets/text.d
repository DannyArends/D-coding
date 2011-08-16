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
  this(double x, double y, string text, Object2D parent){
    super(x,y,8*text.length,16,parent);
    if(text != "") this.lines ~= text;
  }
  
  void render(){
    foreach(int cnt, string line; lines){
      glLoadIdentity();
      glTranslatef(x(),y()+cnt*16,0.0f);
      glScalef(scale,scale,scale);
      glColor4f(r(), g(),  b(), alpha());

      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, getParent().getFontId());
      glListBase(getParent().getFontBase()-32+(128*type));
      glCallLists(to!int(line.length),GL_UNSIGNED_BYTE, line.dup.ptr);
      glDisable(GL_TEXTURE_2D);
    }
  }
  
  Object2DType getType(){ return Object2DType.TEXT; }
  
  void addLine(string line){ 
    if(lines.length < maxlines || maxlines == -1){
      lines ~= line; 
    }
    if(lines.length == maxlines){
      removeLine();
      lines ~= line; 
    }
  }
  
  void setText(string text){
    lines = [text];
  }
  
  void removeLine(){ if(lines != null) lines = lines[1..$]; }
    
  void setScale(double scale){ this.scale = scale; }

  void setMaxLines(int maxlines){ 
    this.maxlines = maxlines;
    if(maxlines < 0) this.maxlines = -1;
  }
  
  GLfloat sy(){ return 16*lines.length; }
private:
  int      maxlines = -1;
  double   scale = 0.8f;
  int      type=0;
  string[] lines;
}
