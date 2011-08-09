module gui.objects.location;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.camera;

class Location{
public:
  this(){
    this(0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z){
    loc[0]=x;
    loc[1]=y;
    loc[2]=z;
  }
  
  void move(double x, double y, double z){
    loc[0]+=x;
    loc[1]+=y;
    loc[2]+=z;
  }
  
  void setLocation(double x, double y, double z){
    loc[0]=x;
    loc[1]=y;
    loc[2]=z;
  }
  
  GLfloat x(){ return loc[0]; }
  GLfloat y(){ return loc[1]; }
  GLfloat z(){ return loc[2]; }
  
private:
  double[3] loc;
};
