/**
 * \file tilemap.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module game.maps.tilemap;

import core.thread;
import std.array;
import std.conv;
import std.string;

import core.typedefs.types;
import game.objects.tile;
import game.mover;

class TileMap{
public:
  int x;
  int y;
  
  this(int x, int y){
  	this.x=x;
  	this.y=y;
  	tiles = newmatrix!TileType(x, y);
  }
  
  double getMovementCost(Mover mover, int x, int y, int xp, int yp){
    return 1.0;
  }
  
  bool isValidLocation(Mover mover, int x,int y, int xp,int yp){
    return false;
  }
  
  TileType getTileType(int x, int y){
    return BLOCKEDTILE; 
  }
  
  void pathFinderVisited(int x, int y){
  
  }
  
  bool isBlocked(Mover mover, int x, int y){
    return true;
  }
  
private:
  TileType[][] tiles;
}