/******************************************************************//**
 * \file src/gui/objects/quad.d
 * \brief 3D quad definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.quad;

import std.array, std.stdio, std.conv;
import gl.gl_1_0, gl.gl_1_1;
import gui.objects.object3d;

class Quad : Object3D{
  public:
    this(double x, double y, double z){ super(x,y,z); }
    
    override void buffer(){ }
    
    override void render(int faceType = GL_QUADS){
      glToLocation();
      glColor4f(r(), g(),  b(), alpha());
      if(textureid != -1){
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, textureid);
      }
      glBegin(faceType);
        glTexCoord2f(1.0, 0.0);
        glVertex3f(  sx(),  sx(),  0.0f );
        
        glTexCoord2f(0.0, 0.0);
        glVertex3f( -sx(),  sx(),  0.0f );
        
        glTexCoord2f(0.0, 1.0);
        glVertex3f( -sx(), -sx(),  0.0f );
        
        glTexCoord2f(1.0, 1.0);
        glVertex3f(  sx(), -sx(),  0.0f );
      glEnd();
      if(textureid != -1) glDisable(GL_TEXTURE_2D);
      glPopMatrix();
    }

    override int getFaceType(){ return GL_QUADS; }
}
