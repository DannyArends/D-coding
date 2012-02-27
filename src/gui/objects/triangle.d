/******************************************************************//**
 * \file src/gui/objects/triangle.d
 * \brief 3D triangle definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.triangle;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.objects.object3d;

class Triangle : Object3D{
public:

  this(){ super(); }
  this(double x, double y, double z, Object3D o = null){ super(x,y,z,o); }
  
  void buffer(){ }
  
  void render(int faceType = GL_TRIANGLES){
    glToLocation();
    glColor4f(r(), g(),  b(), alpha());
    if(textureid != -1){
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, textureid);
    }
    glBegin(faceType);
      glVertex3f(  0.0f,  sx(),  0.0f );
      glVertex3f( -sx(), -sx(),  0.0f );
      glVertex3f(  sx(), -sx(),  0.0f );
    glEnd();
    glPopMatrix();
  }
  
  int getFaceType(){ return GL_TRIANGLES; }
}
