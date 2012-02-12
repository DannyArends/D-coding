/**********************************************************************
 * \file src/core/arrays/ray.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
/**********************************************************************
 * \file src/core/arrays/ray.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.ray;

import core.arrays.algebra;
import std.math;

struct camera{
  double[] location;
  double[] direction;
  double toscreen = 3;
  double height,width;
};

struct world{
  double[] right;
  double[] viewplane;
  double[] up;
};

class Ray{
  double[] location;
  double[] direction;
  double magnitude;
  
  this(camera c){
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

Ray constructRayThroughPixel(world w, camera c, int x, int y){
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
