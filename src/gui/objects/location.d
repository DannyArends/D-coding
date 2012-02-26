/******************************************************************//**
 * \file src/gui/objects/location.d
 * \brief 3D location definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.location;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

/*! \brief 3D Location class
 *
 *  3D Location class
 */
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
  
  void setLocation(double x, double y, double z){
    loc[0]=x;
    loc[1]=y;
    loc[2]=z;
  }
  
  double[] getLocation(){ return loc; }
  
  @property double[] location(){ return loc; }
  @property GLfloat x(){ return loc[0]; }
  @property GLfloat y(){ return loc[1]; }
  @property GLfloat z(){ return loc[2]; }
  
private:
  double loc[3];
}
