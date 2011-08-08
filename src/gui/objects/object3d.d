module gui.objects.object3d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.camera;
import gui.objects.location;

abstract class Object3D : Location{
  this(){
    super(0.0, 0.0, 0.0);
    setRotation(0.0, 0.0, 0.0);
    setSize(1.0, 1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z){
    super(x, y, z);
    setRotation(0.0, 0.0, 0.0);
    setSize(1.0, 1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz){
    super(x, y, z);
    setRotation(rx, ry, rz);
    setSize(1.0, 1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz, double sx, double sy, double sz){
    super(x,y,z);
    setRotation(rx, ry, rz);
    setSize(sx, sy, sz);
    setColor(1.0, 1.0, 1.0);
  }
  
  void setRotation(double rx, double ry, double rz){
    rot[0]=rx;
    rot[1]=ry;
    rot[2]=rz;
  }
  
  void setSize(double sx, double sy, double sz){
    size[0]=sx;
    size[1]=sy;
    size[2]=sz;  
  }
  
  void setColor(double r, double g, double b, double a = 1.0){
    if(r >=0 && r <= 1) color[0]=r;
    if(g >=0 && g <= 1) color[1]=g;
    if(b >=0 && b <= 1) color[2]=b;
    if(a >=0 && a <= 1) color[3]=a;  
  }
  
  void rotate(double rx, double ry, double rz){
    rot[0]+=rx;
    rot[1]+=ry;
    rot[2]+=rz;
  }
  
  void adjustSize(double factor = 1.0){
    size[0]*=factor;
    size[1]*=factor;
    size[2]*=factor;
  }
  
  abstract void render(Camera c);

  GLfloat rx(){ return rot[0]; }
  GLfloat ry(){ return rot[1]; }
  GLfloat rz(){ return rot[2]; }
  
  GLfloat r(){ return color[0]; }
  GLfloat g(){ return color[1]; }
  GLfloat b(){ return color[2]; }
  GLfloat alpha(){ return color[3]; }
  
  GLfloat sx(){ return size[0]; }
  GLfloat sy(){ return size[1]; }
  GLfloat sz(){ return size[2]; }
private:
  double[4] color;
  double[3] rot;
  double[3] size;
};
