module gui.objects.force;

import std.array;
import std.stdio;
import std.conv;

import core.arrays.algebra;

import gui.objects.object3d;
import gui.objects.vector3d;

class NullForce : Force{
  this(){
    super(0.0,0.0,0.0,0.0,0.0,0.0);
  }
  
  void act(Object3D origin, Object3D target){ }
}

class Gravity : Force{
  this(){
    super(0.0,0.0,0.0,0.0,-9.8,0.0);
  }
  
  void act(Object3D origin, Object3D target){
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
  
  void act(Object3D origin, Object3D target){
    //writefln("Distance between objects: %f",magnitude(subtract!double(origin.location,target.location)));
    if(magnitude(subtract!double(origin.location,target.location)) < 3){
      target.addImpulse(getDirection(), getMagnitude());
    }
  }
}

class Force : Vector3D{
  this(double x, double y, double z){
    this(x,y,z, 1.0, 1.0, 1.0);
  }
  
  this(double x, double y, double z, double dx, double dy, double dz){
    super(x,y,z,dx,dy,dz);
  }
  
  abstract void act(Object3D origin, Object3D target);
  
  double[] getDirection(){
    return normalize(applyRandomness(getRotation(), rnd));
  }
  
  double getMagnitude(){
    return magnitude(applyRandomness(getRotation(), rnd));
  }
  
  void setRandomness(int x, int y, int z){
    rnd[0] = x;
    rnd[1] = y;
    rnd[2] = z;
  }
  
  private:
  int rnd[3] = [0, 0, 0];
}
