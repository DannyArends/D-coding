module game.tilemap;

import std.array;
import std.conv;
import std.string;

import core.typedefs.types;

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
