/******************************************************************//**
 * \file src/core/typedefs/vector3d.d
 * \brief 3D vector definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.vector3d;

import std.array;
import std.stdio;
import std.conv;

import core.typedefs.location;

/*! \brief 3D Vector class
 *
 *  3D Vector class
 */
class Vector3D : Location{
  this(double x, double y, double z){
    this(x,y,z, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z, double rx, double ry, double rz){
    super(x,y,z);
    setRotation(rx,ry,rz);
  }

  void setRotation(double rx, double ry, double rz){
    rot[0]=rx;
    rot[1]=ry;
    rot[2]=rz;
  }
    
  void rotate(double rx, double ry, double rz){
    rot[0]+=rx;
    rot[1]+=ry;
    rot[2]+=rz;
  }

  @property{
    double[] direction(){ return rot; }
    float rx(){ return rot[0]; }
    float ry(){ return rot[1]; }
    float rz(){ return rot[2]; }
  }
  
  private:
    double[3] rot;
}
