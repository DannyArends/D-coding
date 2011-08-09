module gui.objects.line;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.object3d;

class Line : Object3D{
public:
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void render(Camera camera){
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y-y(),camera.z-z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    glColor4f(r(), g(),  b(), alpha());
    glBegin(GL_LINES);
      glVertex3f(0.0,0.0,0.0);
      glVertex3f(sx(),sy(),sz());
    glEnd();
  }
}
