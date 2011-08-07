module gui.objects.quad;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.location;

class Quad : Object3D{
  
  this(double x, double y, double z){
    super(x,y,z);
  }
  
  void render(Camera camera){
    glLoadIdentity( );
    glTranslatef(camera.x+x(),camera.y-y(),camera.z-z());
        
    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
            
    glBegin(GL_QUADS);
      glVertex3f(  sx(),  sx(),  0.0f ); /* Top Right Of The Quad    */
      glVertex3f( -sx(),  sx(),  0.0f ); /* Top Left Of The Quad     */
      glVertex3f( -sx(), -sx(),  0.0f ); /* Bottom Left Of The Quad  */
      glVertex3f(  sx(), -sx(),  0.0f ); /* Bottom Right Of The Quad */
    glEnd();
  }

private:
  double[3] rot;
  double[3] size;
};