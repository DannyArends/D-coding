/******************************************************************//**
 * \file src/gui/objects/line.d
 * \brief 3D line definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
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
    
    override void buffer(){ }
  
    override void render(int faceType = GL_LINES){
      glToLocation();
      glColor4f(r(), g(),  b(), alpha());
      glBegin(GL_LINES);
        glVertex3f(0.0,0.0,0.0);
        glVertex3f(sx(),sy(),sz());
      glEnd();
      glPopMatrix();
    }

    override int getFaceType(){ return GL_LINES; }
}
