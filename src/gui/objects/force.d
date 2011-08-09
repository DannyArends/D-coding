module gui.objects.force;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.camera;
import gui.objects.location;

class Force : Location{
public:  
  this(int timespan = -1){
    super(0.0, 0.0, 0.0);
    setDirection(0.0, 0.0, 0.0);
    this.timespan  = timespan;
    this.age       = 0;
  }
  
  this(double x, double y, double z, int timespan = -1){
    super(x, y, z);
    setDirection(0.0, 0.0, 0.0);
    this.timespan  = timespan;
    this.age       = 0;
  }
  
  this(double x, double y, double z, double dx, double dy, double dz, int timespan = -1){
    super(x, y, z);
    setDirection(dx, dy, dz);
    this.timespan  = timespan;
    this.age       = 0;
  }
  
  void setDirection(double x, double y, double z){
    direction[0]=x;
    direction[1]=y;
    direction[2]=z;
  }
  
  GLfloat dx(){ return direction[0]; }
  GLfloat dy(){ return direction[1]; }
  GLfloat dz(){ return direction[2]; }
  
private:
  double[3] direction;
  int       timespan, age;
}
