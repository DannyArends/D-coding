/**********************************************************************
 * \file src/gui/objects/box.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.box;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.object3d;

class Box : Object3D{
public:
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void render(Camera camera, int faceType = GL_QUADS){
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y+y(),camera.z+z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    glColor4f(r(), g(),  b(), alpha());
    glBegin(faceType);
      glVertex3f(sx() ,sy(),-sz());        // Top Right Of The Quad (Top)
      glVertex3f(-sx(),sy(),-sz());        // Top Left Of The Quad (Top)
      glVertex3f(-sx(),sy(),sz());         // Bottom Left Of The Quad (Top)
      glVertex3f(sx() ,sy(),sz());         // Bottom Right Of The Quad (Top)

      glVertex3f(sx() ,-sy(),sz());        // Top Right Of The Quad (Bottom)
      glVertex3f(-sx(),-sy(),sz());        // Top Left Of The Quad (Bottom)
      glVertex3f(-sx(),-sy(),-sz());       // Bottom Left Of The Quad (Bottom)
      glVertex3f(sx() ,-sy(),-sz());       // Bottom Right Of The Quad (Bottom)

      glVertex3f(sx() ,sy() ,sz());        // Top Right Of The Quad (Front)
      glVertex3f(-sx(),sy() ,sz());        // Top Left Of The Quad (Front)
      glVertex3f(-sx(),-sy(),sz());        // Bottom Left Of The Quad (Front)
      glVertex3f(sx() ,-sy(),sz());        // Bottom Right Of The Quad (Front)

      glVertex3f(sx() ,-sy(),-sz());       // Top Right Of The Quad (Back)
      glVertex3f(-sx(),-sy(),-sz());       // Top Left Of The Quad (Back)
      glVertex3f(-sx(),sy() ,-sz());       // Bottom Left Of The Quad (Back)
      glVertex3f(sx() ,sy() ,-sz());       // Bottom Right Of The Quad (Back)

      glVertex3f(-sx(),sy() ,sz());        // Top Right Of The Quad (Left)
      glVertex3f(-sx(),sy() ,-sz());       // Top Left Of The Quad (Left)
      glVertex3f(-sx(),-sy(),-sz());       // Bottom Left Of The Quad (Left)
      glVertex3f(-sx(),-sy(),sz());        // Bottom Right Of The Quad (Left)

      glVertex3f(sx() ,sy() ,-sz());       // Top Right Of The Quad (Right)
      glVertex3f(sx() ,sy() ,sz());        // Top Left Of The Quad (Right)
      glVertex3f(sx() ,-sy(),sz());        // Bottom Left Of The Quad (Right)
      glVertex3f(sx() ,-sy(),-sz());       // Bottom Right Of The Quad (Right)
    glEnd();
  }
  
  int getFaceType(){ return GL_QUADS; }
}
