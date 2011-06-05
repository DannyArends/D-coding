/**
 * \file ray.D
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: Ray
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

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
  
  double[] endpoint() {
		double[] endlocation;
    endlocation = addnmultiply!double(direction,location, magnitude);
    return endlocation;
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