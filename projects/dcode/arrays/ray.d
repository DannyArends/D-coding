/******************************************************************//**
 * \file dcode/arrays/ray.d
 * \brief Ray tracing definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.arrays.ray;

import std.math;
import dcode.structs.camera, dcode.arrays.algebra;

struct world{
  double[] right;
  double[] viewplane;
  double[] up;
};

class Ray{
  double[] location;
  double[] direction;
  double magnitude;
  
  this(Camera c){
    location  = c.location;
    direction = c.direction;
    magnitude = c.toscreen;
  }
  
  double[] endpoint(){
    return addnmultiply!double(direction,location, magnitude);
  }
  
  void norm(){
    direction = normalize!double(direction);
  }
}

Ray constructRayThroughPixel(world w, Camera c, int x, int y){
  Ray ray = new Ray(c);
  double[] endlocation = ray.endpoint();

  double upOffset = -1 * y - (c.height / 2);
  double rightOffset = x - (c.width / 2);
  
  endlocation = addnmultiply!double(endlocation, w.right, rightOffset);
  endlocation = addnmultiply!double(endlocation, w.viewplane, upOffset);

  ray.direction = subtract!double(endlocation,c.location);
  ray.norm();
  return ray;
}

