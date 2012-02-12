/**********************************************************************
 * \file src/game/tilemap.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tilemap;

import std.array;
import std.conv;
import std.string;

import core.arrays.types;

import game.tile;
import game.mover;

class TileMap{
public:
  uint mapuid;
  uint x;
  uint y;
  
  this(uint x, uint y){
    this.x=x;
    this.y=y;
    tiles = newmatrix!TileType(x, y, BLOCKEDTILE);
  }
  
  double getMovementCost(Mover mover, uint x, uint y, uint xp, uint yp){
    return 1.0;
  }
  
  bool isValidLocation(Mover mover, uint x,uint y, uint xp, uint yp){
    return false;
  }
  
  TileType getTileType(uint x, uint y){
    return BLOCKEDTILE; 
  }
  
  void pathFinderVisited(uint x, uint y){
  
  }
  
  bool isBlocked(Mover mover, uint x, uint y){
    return true;
  }
  
private:
  TileType[][] tiles;
}
