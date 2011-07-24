/*
 * \file emitter.d - Abstract emitter class
 * 
 * Copyright (c) 2011 Danny Arends
 * 
 */

module game.objects.emitter;

import std.array;
import std.stdio;
import std.conv;

import game.objects.particle;
import game.objects.force;

class Emitter(Emission) : Particle{
public:
  this(int n){
    super();
    emissions.length = n;
  }
  
  this(double[3] location, int n){
    super(location);
    emissions.length = n;
  }
  
  void addForce(Force f){
    emissionforces ~= f; 
  }
  
  void exude(){
    foreach(Force f ; emissionforces){
      foreach(Emission e ; emissions){
        e.applyForce(f);
      }
    }
  }
  
  Emission[] emissions;
  Force[]    emissionforces;
}

void test(){
  Emitter!(Particle) test = new Emitter!(Particle)(100);
  test.addForce(cast(Force)[0,5,0]);
  test.exude( );
}
