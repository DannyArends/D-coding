/******************************************************************//**
 * \file src/core/typedefs/location.d
 * \brief 3D location definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.location;

import std.array, std.stdio, std.conv;

/*! \brief 3D Location class
 *
 *  3D Location class
 */
class Location{
public:
  this(){ this(0.0, 0.0, 0.0); }
  
  this(string input){
    auto elements = input.split(":");
    if(elements.length >= 1) loc[0] = to!double(elements[0]);
    if(elements.length >= 2) loc[1] = to!double(elements[1]);
    if(elements.length >= 3) loc[2] = to!double(elements[2]);
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
  @property float x(){ return loc[0]; }
  @property float y(){ return loc[1]; }
  @property float z(){ return loc[2]; }
  
  override string toString(){ 
    return to!string(loc[0]) ~ ":" ~ to!string(loc[1]) ~ ":" ~ to!string(loc[2]); 
  }
  
private:
  double loc[3] = [0.0, 0.0, 0.0];
}
