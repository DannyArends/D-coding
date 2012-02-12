module gui.objects.vector3d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.location;

class Vector3D : Location{
  this(double x, double y, double z){
    this(x,y,z, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z, double rx, double ry, double rz){
    super(x,y,z);
    setRotation(rx,ry,rz);
  }

  void setRotation(double rx, double ry, double rz){
    rot[0]=rx;
    rot[1]=ry;
    rot[2]=rz;
  }
  
  double[] getRotation(){ return rot; }
  
  void rotate(double rx, double ry, double rz){
    rot[0]+=rx;
    rot[1]+=ry;
    rot[2]+=rz;
  }

  @property GLfloat rx(){ return rot[0]; }
  @property GLfloat ry(){ return rot[1]; }
  @property GLfloat rz(){ return rot[2]; }
  
  private:
    double[3] rot;
}
