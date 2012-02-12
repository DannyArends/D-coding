module gui.objects.line;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.object3d;

class Line : Object3D{
  public:
    this(double x, double y, double z){
      super(x,y,z);
    }

    this(double x, double y, double z,double sx, double sy, double sz){
      super(x,y,z,0.0,0.0,0.0,sx,sy,sz);
    }
    
    void buffer(){ }
  
    void render(int faceType = GL_LINES){
      glToLocation();
      glColor4f(r(), g(),  b(), alpha());
      glBegin(GL_LINES);
        glVertex3f(0.0,0.0,0.0);
        glVertex3f(sx(),sy(),sz());
      glEnd();
      glPopMatrix();
    }

    int getFaceType(){ return GL_LINES; }
}
