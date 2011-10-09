module gui.objects.quad;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.objects.camera;
import gui.objects.object3d;

class Quad : Object3D{
public:
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void setTexture(int id){
    textureid=id;
  }
  
  void render(Camera camera, int faceType = GL_QUADS){
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y+y(),camera.z+z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    glColor4f(r(), g(),  b(), alpha());
    if(textureid != -1){
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, textureid);
    }
    glBegin(faceType);
      if(textureid != -1) glTexCoord2f(1.0, 1.0);
      glVertex3f(  sx(),  sx(),  0.0f );
      if(textureid != -1) glTexCoord2f(0.0, 1.0);
      glVertex3f( -sx(),  sx(),  0.0f );
      if(textureid != -1) glTexCoord2f(0.0, 0.0);
      glVertex3f( -sx(), -sx(),  0.0f );
      if(textureid != -1) glTexCoord2f(1.0, 0.0);
      glVertex3f(  sx(), -sx(),  0.0f );
    glEnd();
    if(textureid != -1) glDisable(GL_TEXTURE_2D);
  }

  int getFaceType(){ return GL_QUADS; }

private:  
  int textureid = -1;
}
