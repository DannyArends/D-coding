/**
 * \file mover.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module game.mover;

import core.thread;
import std.array;
import std.conv;
import std.string;

import game.objects.tile;

class Mover{
public:
  this(double s){
    speed = s;
  }
  
  this(TileType[] a, double s){
    allowed = a;
    speed = s;
  }
  
  bool canMoveTo(TileType t){
    foreach(TileType a; allowed){
      if(t==a) return true;
    }
    return false;
  }
  
  double costToMoveTo(TileType t){
    if(canMoveTo(t)) return (t.cost * speed);
    assert(0);
  }
  
private:
  TileType[] allowed;
  double speed;
}
