module gui.objects.quad;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.object3d;

class Quad : Object3D{
  
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
      glVertex3f(  sx(),  sx(),  0.0f );
      glVertex3f( -sx(),  sx(),  0.0f );
      glVertex3f( -sx(), -sx(),  0.0f );
      glVertex3f(  sx(), -sx(),  0.0f );
    glEnd();
  }
  
  int getFaceType(){ return GL_QUADS; }
};