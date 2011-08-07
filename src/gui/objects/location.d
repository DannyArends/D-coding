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
  
  GLfloat x(){ return loc[0]; }
  GLfloat y(){ return loc[1]; }
  GLfloat z(){ return loc[2]; }
  
private:
  double[3] loc;
};

abstract class Object3D : Location{
  this(){
    super(0.0, 0.0, 0.0);
    setRotation(0.0, 0.0, 0.0);
    setSize(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z){
    super(x, y, z);
    setRotation(0.0, 0.0, 0.0);
    setSize(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz){
    this(x, y, z);
    setRotation(rx, ry, rz);
    setSize(1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz, double sx, double sy, double sz){
    super(x,y,z);
    setRotation(rx, ry, rz);
    setSize(sx, sy, sz);
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
  
  GLfloat sx(){ return size[0]; }
  GLfloat sy(){ return size[1]; }
  GLfloat sz(){ return size[2]; }
private:
  double[3] rot;
  double[3] size;
}