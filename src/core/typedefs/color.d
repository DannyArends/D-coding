module core.typedefs.color;

import std.array;
import std.stdio;
import std.conv;
import std.random;

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
  
  this(ubyte c[], double alpha = 1.0){
    color[0]=c[0]/255.0;
    color[1]=c[1]/255.0;
    color[2]=c[2]/255.0;
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
  
  void updateColor(int i, double value){
    setColor(0.0,0.0,0.0,1.0);
    color[i]=value;
  }
  
  @property float r(){ return color[0]; }
  @property float g(){ return color[1]; }
  @property float b(){ return color[2]; }
  @property float alpha(){ return color[3]; }
  
private:
  double[4] color;
}
