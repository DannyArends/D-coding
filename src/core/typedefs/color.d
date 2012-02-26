/******************************************************************//**
 * \file src/core/typedefs/color.d
 * \brief Color class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.color;

import std.array;
import std.stdio;
import std.conv;
import std.random;

/*! \brief Internal representation of color
 *
 *  Internal representation of color, stored as double[4] Range: [0-1]
 */
class Color{
  public:
    this(){
      random();
    }
  
    this(double r, double g, double b, double alpha = 1.0){
      color[0]=r;
      color[1]=g;
      color[2]=b;
      color[3]=alpha;
    }
  
    this(ubyte c[], double alpha = 1.0){
      this(c[0]/255.0, c[1]/255.0, c[2]/255.0, alpha);
    }
  
    void random(){
      color[0]= uniform(0.0, 1.0);
      color[1]= uniform(0.0, 1.0);
      color[2]= uniform(0.0, 1.0);
      color[3]= uniform(0.0, 1.0);
    }
  
    void setColor(double r, double g, double b, double alpha = 1.0){
      color[0]=r;
      color[1]=g;
      color[2]=b;
      color[3]=alpha;
    }
  
    void updateColor(int i, double value){
      setColor(0.0,0.0,0.0,1.0);
      color[i]=value;
    }
  
    @property float r(){ return color[0]; }
    @property float g(){ return color[1]; }
    @property float b(){ return color[2]; }
    @property float alpha(){ return color[3]; }
  
  private:
    double[4] color;
}
