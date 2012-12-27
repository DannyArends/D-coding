/******************************************************************//**
 * \file dcode/structs/camera.d
 * \brief camera definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.structs.camera;

import std.array, std.stdio, std.conv;
import dcode.structs.vector3d;

/*! \brief Camera class
 *
 *  Representation of a Camera
 */
class Camera : Vector3D{
public:
  //! Constructor Camera class, default at [-1.5, 0.0 , 6.0] looking at [0,0,0].
  this(){ this(-1.5, 0.0, -6.0, 0.0, 0.0, 0.0); }
  
  this(double x, double y, double z){
    this(x, y, z, 0.0, 0.0, 0.0);
  }
  
  this(double x, double y, double z,double rx, double ry, double rz){
    super(x,y,z,rx,ry,rz);
  }
  //! Screen width used in ray-tracing.  
  @property double width(){ return _width; }
  //! Screen height used in ray-tracing.  
  @property double height(){ return _height; }
  //! Distance to screen used in ray-tracing.  
  @property double toscreen(){ return _toscreen; }
  
  private:
    double _toscreen = 3;
    double _height;
    double _width;
}

