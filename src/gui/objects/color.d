module gui.objects.color;

import std.array;
import std.stdio;
import std.conv;
import std.random;

import gl.gl_1_0;
import gui.objects.camera;

class Color{
public:
  this(){
    random();
  }
  
  this(double r, double g, double b, double alpha = 1.0){
    color[0]=r;
    color[1]=g;
    color[2]=b;
    color[3]=alpha;
  }
  
  void random(){
    color[0]= uniform(0.0, 1.0);
    color[1]= uniform(0.0, 1.0);
    color[2]= uniform(0.0, 1.0);
    color[3]= uniform(0.0, 1.0);
  }
  
  void setColor(double r, double g, double b, double alpha = 1.0){
    color[0]=r;
    color[1]=g;
    color[2]=b;
    color[3]=alpha;
  }
  
  @property GLfloat r(){ return color[0]; }
  @property GLfloat g(){ return color[1]; }
  @property GLfloat b(){ return color[2]; }
  @property GLfloat alpha(){ return color[3]; }
  
private:
  double[4] color;
}
