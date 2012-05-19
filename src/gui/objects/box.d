/******************************************************************//**
 * \file src/gui/objects/box.d
 * \brief 3D box definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.box;

import std.array, std.stdio, std.conv;
import gl.gl_1_0;
import core.typedefs.camera;
import gui.objects.object3d;

class Box : Object3D{
public:
  this(double x, double y, double z){ super(x,y,z); }
  
  override void render(int faceType = GL_QUADS){
    glToLocation();
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
  
  override int getFaceType(){ return GL_QUADS; }
}
