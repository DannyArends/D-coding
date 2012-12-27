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

import std.array, std.stdio, std.conv;
import core.typedefs.location;
import core.arrays.algebra;

/*! \brief Abstract Vector3D class
 *
 *  Defines a vector in 3D space 
 */
class Vector3D : Location{
  this(double x, double y, double z){ this(x,y,z, 0.0, 0.0, 0.0); }
  
  this(double x, double y, double z, double rx, double ry, double rz){
    super(x,y,z);
    rot = [rx,ry,rz];
  }

  /*! \brief Rotate this vector
   *  \param r 3D rotation to add<br> */
  void rotate(in double[] r){ rot = add(rot,r); }

  @property{
    double[] direction(in double[] r = null){ if(r !is null){ rot=r; } return rot; }
    float rx(){ return rot[0]; }   //!< Rotation X component
    float ry(){ return rot[1]; }   //!< Rotation Y component
    float rz(){ return rot[2]; }   //!< Rotation Z component
  }
  
  private:
    double[3] rot;
}
