module gui.objects.sphere;

import std.array;
import std.stdio;
import std.conv;
import std.math;

import gl.gl_1_0;

import gui.objects.camera;
import gui.objects.object3d;

class Sphere : Object3D{
  
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
    for(uint i = 0; i <= subdivisions; i++ ){
      glBegin(GL_TRIANGLE_STRIP);
      double si = i/2.0;
      double dip = 2*(i+1);
      theta[0] = ((si * twopi) / subdivisions) - PI_2;
      theta[1] = (((si + 1) * twopi) / subdivisions) - PI_2;
      for(uint j = 0; j <= subdivisions; j++ ){
        theta[2] = (subdivisions-j) * twopi / subdivisions;
        e[0] = cos(theta[1]) * cos(theta[2]);
        e[1] = sin(theta[1]);
        e[2] = cos(theta[1]) * sin(theta[2]);
        
        glNormal3f(e[0], e[1], e[2]);
        glTexCoord2f( -(j/subdivisions) , dip/subdivisions );
        glVertex3f(e[0]*sx(), e[1]*sy(), e[2]*sz());
        
        e[0] = cos(theta[0]) * cos(theta[2]);
        e[1] = sin(theta[0]);
        e[2] = cos(theta[0]) * sin(theta[2]);
        
        glNormal3f(e[0], e[1], e[2]);
        glTexCoord2f( -(j/subdivisions) , dip/subdivisions );
        glVertex3f(e[0]*sx(), e[1]*sy(), e[2]*sz());
      }
      glEnd();
    }
  }

private:
  uint subdivisions = 20;
  double theta[3];
  double e[3];
  double twopi      = 2.0*PI;
};