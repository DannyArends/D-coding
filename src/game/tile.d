/******************************************************************//**
 * \file src/game/tile.d
 * \brief Game world tile
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tile;

import std.array, std.conv, std.string;

struct TileType{
  double cost = 0.0;
  char   type = 'B';
  
  this(char id, TileType[] lookup){
    foreach(TileType t; lookup){
      if(t.type==id){
        type = t.type;
        cost = t.cost;
      }
    }
  }
  
  this(double c, char id = 'B'){
    cost = c;
    type = id;
  }

  string toDescription(){ return to!string(type) ~ "\t" ~ to!string(cost); }
  string toString(){ return to!string(type); }
  bool opCmp(TileType t){ return type==t.type; }
}

immutable TileType 
  BLOCKEDTILE   = TileType(0.0 ,'B'),
  WATERTILE     = TileType(2.0 ,'W'),
  GRASSTILE     = TileType(1.0 ,'G'), 
  SANDTILE      = TileType(1.1 ,'S'), 
  HILLTILE      = TileType(1.5 ,'H'), 
  MOUNTAINTILE  = TileType(2.5 ,'M');
