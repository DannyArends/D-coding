/******************************************************************//**
 * \file src/gui/objects/object3d.d
 * \brief 3D object definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.object3d;

import std.array, std.stdio, std.conv, std.random;
import core.typedefs.camera, core.typedefs.vector3d, core.typedefs.color;
import core.arrays.algebra;
import gl.gl_1_0;
import gui.textureloader;

/*! \brief Abstract 3D Object
 *
 *  Abstract 3D Object class
 */
abstract class Object3D : Vector3D{
public:  
  this(Object3D parent = null){ this(0.0, 0.0, 0.0, parent); }
  
  this(double x, double y, double z, Object3D parent = null){
    this(x, y, z,0.0,0.0,0.0,parent);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz, Object3D parent = null){
    this(x, y, z,rx, ry, rz,1.0,1.0,1.0,parent);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz, double sx, double sy, double sz, Object3D parent = null){
    super(x, y, z, rx, ry, rz);
    setSize(sx, sy, sz);
    setColor(1.0, 1.0, 1.0);
    setImpulse(0.0,0.0,0.0);
    this.parent=parent;
  }
      
  void setSize(double sx, double sy, double sz){
    size[0]=sx;
    size[1]=sy;
    size[2]=sz;  
  }
  
  void setColor(double r, double g, double b, double a = 1.0){
    color = new Color(r,g,b,a);
  }
  
  void setColor(Color c){ color = c; }
  
  void adjustSize(double factor = 1.0){
    size[0]*=factor;
    size[1]*=factor;
    size[2]*=factor;
  }
  
  abstract void buffer();
  abstract void render(int faceType = GL_TRIANGLES);
  abstract int getFaceType();
  
  void addImpulse(double[] direction, double magnitude){
    impulse = add(impulse,multiply(direction,magnitude));
  }
  
  void setImpulse(double ix,double iy, double iz){
    impulse[0] = ix;
    impulse[1] = iy;
    impulse[2] = iz;
  }

  void setLife(int life = 0){
    this.life[0]=life;
    if(life!=0) this.life[1]=uniform(0,life);
  }
  
  void update(){
    if(life[0] > 0){
      move(ix()/100.0,iy()/100.0,iz()/100.0);
      life[1]--;
      if(life[1]==0){
        location = [parent.x,parent.y,parent.z];
        setImpulse(0.0, 0.0, 0.0);
        life[1]=life[0];
      }
    }
  }
  
  void glToLocation(){
    glPushMatrix();    
    glTranslatef(x(),y(),z());
    glRotatef(rx(), 1.0, 0.0, 0.0);
    glRotatef(ry(), 0.0, 1.0, 0.0);
    glRotatef(rz(), 0.0, 0.0, 1.0);
  }
  
  void setTexture(int id){ textureid=id; }
  
  @property bool buffered(){ return _buffered; }
  @property void buffered(bool status){ _buffered=status; }
  
  @property GLfloat r(){ return color.r(); }
  @property GLfloat g(){ return color.g(); }
  @property GLfloat b(){ return color.b(); }
  @property GLfloat alpha(){ return color.alpha(); }
  
  @property GLfloat ix(){ return impulse[0]; }
  @property GLfloat iy(){ return impulse[1]; }
  @property GLfloat iz(){ return impulse[2]; }

  @property GLfloat sx(){ return size[0]; }
  @property GLfloat sy(){ return size[1]; }
  @property GLfloat sz(){ return size[2]; }
  
protected:
  Object3D  parent;
  Color     color;
  double    size[3]    = [1.0,1.0,1.0];
  double    impulse[3] = [0.0,0.0,0.0];
  int       life[2]    = [0,0];
  int       textureid  = -1;
  bool      _buffered;
}
