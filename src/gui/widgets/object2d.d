module gui.widgets.object2d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.color;
import gui.objects.location;

abstract class Object2D : Location{
  this(){
    super(0.0, 0.0, 0.0);
    setSize(1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
  }
  
  this(double x, double y){
    super(x, y, 0.0);
    setSize(1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double sx, double sy){
    super(x, y, 0.0);
    setSize(sx, sy);
    setColor(1.0, 1.0, 1.0);
  }
    
  void setSize(double sx, double sy){
    size[0]=sx;
    size[1]=sy; 
  }
  
  void setColor(double r, double g, double b, double a = 1.0){
    if(color is null){
      color = new Color(r,g,b,a);
    }else{
      color.setColor(r,g,b,a);
    }
  }
  
  abstract void render();

  GLfloat r(){ return color.r(); }
  GLfloat g(){ return color.g(); }
  GLfloat b(){ return color.b(); }
  GLfloat alpha(){ return color.alpha(); }
  
  GLfloat sx(){ return size[0]; }
  GLfloat sy(){ return size[1]; }
private:
  Color     color;
  double[2] size;
};
