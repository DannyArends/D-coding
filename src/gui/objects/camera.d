module gui.objects.camera;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import gui.objects.vector3d;

class Camera : Vector3D{
public:
  this(){
    this(-1.5, 0.0, -6.0, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z){
    this(x, y, z, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz){
    super(x,y,z,rx,ry,rz);
  }
}
