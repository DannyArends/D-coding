module gui.widgets.square;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.widgets.object2d;

class Square : Object2D{
public:
  this(double x, double y, double sx, double sy, Object2D parent){
    super(x,y,sx,sy,parent);
  }
  
  void render(){
    glLoadIdentity();
    glTranslatef(x(),y(),0.0f);
    glColor4f(r(), g(),  b(), alpha());
    glBegin(GL_QUADS);
      glVertex3f(  sx(),  sy(),  0.0f );
      glVertex3f( 0,  sy(),  0.0f );
      glVertex3f( 0, 0,  0.0f );
      glVertex3f(  sx(), 0,  0.0f );
    glEnd();
  }
}
