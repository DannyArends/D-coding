/*
 * \file particle.d - Abstract particle class
 * 
 * Copyright (c) 2011 Danny Arends
 * 
 */

module game.objects.particle;

import std.array;
import std.stdio;
import std.conv;

import core.arrays.algebra;
import game.objects.force;

class Particle{
public:
  this(double[3] location = [0,0,0], int life = 1000){
    this.domicile=location;
    this.location=location;
    this.life=life;
  }
  
  void age(int lifepoints){
    life -= lifepoints;
  }

  void applyForce(Force f){
    impulse = add(impulse,f);
  }

  void move(){
    location = add(location,impulse);
  }

private:
  int       life;
  double[3] domicile;
  double[3] location;
  Force     impulse;
};