module gui.objects.triangle;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.location;

class Triangle : Object3D{
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void render(Camera camera){
    glLoadIdentity( );
    glTranslatef(camera.x+x(),camera.y-y(),camera.z-z());
        
    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
        
    glBegin(GL_TRIANGLES);
      glColor3f(   1.0f,  0.0f,  0.0f ); /* Red                           */
      glVertex3f(  0.0f,  sx(),  0.0f ); /* Top Of Triangle               */
      glColor3f(   0.0f,  1.0f,  0.0f ); /* Green                         */
      glVertex3f( -sx(), -sx(),  0.0f ); /* Left Of Triangle              */
      glColor3f(   0.0f,  0.0f,  1.0f ); /* Blue                          */
      glVertex3f(  sx(), -sx(),  0.0f ); /* Right Of Triangle             */
    glEnd();
  }

private:
  double[3] rot;
  double[3] size;
};