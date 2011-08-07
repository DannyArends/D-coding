module gui.objects.camera;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.location;

class Camera : Location{
public:
  this(){
    this(-1.5, 0.0, -6.0, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z){
    this(x, y, z, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz){
    super(x,y,z);
    rot[0]=rx;
    rot[1]=ry;
    rot[2]=rz;
  }
  
  void rotate(double rx, double ry, double rz){
    rot[0]+=rx;
    rot[1]+=ry;
    rot[2]+=rz;
  }
  
  GLfloat rx(){ return rot[0]; }
  GLfloat ry(){ return rot[1]; }
  GLfloat rz(){ return rot[2]; }
  
private:
  double[3] rot;
};