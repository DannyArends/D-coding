/**
 * \file tile.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module game.objects.tile;

import core.thread;
import std.array;
import std.conv;
import std.string;

struct TileType{
  double cost;
  
  this(double c){
    cost=c;
  }
};

immutable TileType 
  BLOCKEDTILE   = TileType(double.max),
  WATERTILE     = TileType(2.0),
  GRASSTILE     = TileType(1.0), 
  SANDTILE      = TileType(1.1), 
  HILLTILE      = TileType(1.5), 
  MOUNTAINTILE  = TileType(2.5);