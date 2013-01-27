module obj.button;
import std.stdio, std.conv, std.file, std.utf, std.string;
import ext.opengl.gl, ext.sdl.sdl;
import objects, window;

alias void function(GLint, GLint) OnClick;

void echoname(GLint x, GLint y){
  writeln("Name");
}

class Button : Square{
  this(GLint x, GLint y, GLint sx, GLint sy, OnClick fun, GLfloat[4] c = WHITE){
    super(x, y, sx, sy, c);
    onclick = fun;
  }

  override void render(Window w){ super.render(w); }
  void onClick(GLint x, GLint y){ onclick(x,y); }
  private:
    OnClick onclick;
}

