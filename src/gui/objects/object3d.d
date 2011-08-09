module gui.objects.object3d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.camera;
import gui.objects.color;
import gui.objects.location;

abstract class Object3D : Location{
public:  
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
    if(color is null){
      color = new Color(r,g,b,a);
    }else{
      color.setColor(r,g,b,a);
    }
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
  
  abstract void render(Camera c, int faceType = GL_TRIANGLES);
  abstract int getFaceType();

  GLfloat rx(){ return rot[0]; }
  GLfloat ry(){ return rot[1]; }
  GLfloat rz(){ return rot[2]; }
  
  GLfloat r(){ return color.r(); }
  GLfloat g(){ return color.g(); }
  GLfloat b(){ return color.b(); }
  GLfloat alpha(){ return color.alpha(); }
  
  GLfloat sx(){ return size[0]; }
  GLfloat sy(){ return size[1]; }
  GLfloat sz(){ return size[2]; }
private:
  Color     color;
  double[3] rot;
  double[3] size;
}
