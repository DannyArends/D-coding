/******************************************************************//**
 * \file src/gui/objects/force.d
 * \brief Abstract concept of force
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.force;

import std.array, std.stdio, std.conv;
import core.arrays.algebra;
import core.typedefs.vector3d;
import gui.objects.object3d;

class NullForce : Force{
  this(){ super(0.0,0.0,0.0,0.0,0.0,0.0); }
  override void act(Object3D origin, Object3D target){ }
}

class Gravity : Force{
  this(){ super(0.0,0.0,0.0,0.0,-9.8,0.0); }
  
  override void act(Object3D origin, Object3D target){
    if(target.location[1] >= origin.location[1]){
      target.addImpulse(getDirection(), getMagnitude());
    }else{
      target.setImpulse(0.0,0.0,0.0);
    }
  }
}

class Fountain : Force{
  this(){
    super(0.0,0.0,0.0,0.0,56.0,0.0);
    setRandomness(1000,20,500);
  }
  
  override void act(Object3D origin, Object3D target){
    //writefln("Distance between objects: %f",magnitude(subtract!double(origin.location,target.location)));
    if(magnitude(subtract!double(origin.location,target.location)) < 3){
      target.addImpulse(getDirection(), getMagnitude());
    }
  }
}

class Force : Vector3D{
  this(double x, double y, double z){ this(x,y,z, 1.0, 1.0, 1.0); }
  
  this(double x, double y, double z, double dx, double dy, double dz){
    super(x,y,z,dx,dy,dz);
  }
  
  abstract void act(Object3D origin, Object3D target);
  
  double[] getDirection(){
    return normalize(applyRandomness(direction, rnd));
  }
  
  double getMagnitude(){
    return magnitude(applyRandomness(direction, rnd));
  }
  
  void setRandomness(int x, int y, int z){
    rnd[0] = x;
    rnd[1] = y;
    rnd[2] = z;
  }
  
  private:
    int rnd[3] = [0, 0, 0];
}
