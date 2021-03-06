/******************************************************************//**
 * \file dcode/structs/color.d
 * \brief Color class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.structs.color;

import std.array, std.stdio, std.conv, std.random;

/*! \brief Internal representation of color
 *
 *  Internal representation of color, stored as double[4] Range: [0-1]
 */
class Color{
  public:
    //! Constructor Color class, default random color.
    this(){ random(); }

    this(string colorname){
      switch(colorname){
        case "red":   color = [1,0,0,1]; break;
        case "green": color = [0,1,0,1]; break;
        case "blue":  color = [0,0,1,1]; break;
        case "black": color = [0,0,0,1]; break;
        case "white": color = [1,1,1,1]; break;
        default:      color = [1,1,1,0.3]; break;
      }
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
  
    //! Set the color to a random color.
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
  
    @property float r(){ return color[0]; }      //!< Red color component [0..1]
    @property float g(){ return color[1]; }      //!< Green color component [0..1]
    @property float b(){ return color[2]; }      //!< Blue color component [0..1]
    @property float alpha(){ return color[3]; }  //!< Alpha color component [0..1]
  
  private:
    double[4] color;
}

