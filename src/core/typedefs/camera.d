/******************************************************************//**
 * \file src/core/typedefs/camera.d
 * \brief camera definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.camera;

import std.array, std.stdio, std.conv;
import core.typedefs.vector3d;

/*! \brief Camera
 *
 *  Representation of a Camera
 */
class Camera : Vector3D{
public:
  this(){ this(-1.5, 0.0, -6.0, 0.0, 0.0, 0.0); }
  
  this(double x, double y, double z){
    this(x, y, z, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz){
    super(x,y,z,rx,ry,rz);
  }
  
  @property double width(){ return _width; }
  @property double height(){ return _height; }
  
  double toscreen = 3;
  double _height;
  double _width;
}
