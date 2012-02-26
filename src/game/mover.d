/******************************************************************//**
 * \file src/game/mover.d
 * \brief Mover class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/

module game.mover;

import core.thread;
import std.array;
import std.conv;
import std.string;

import game.tile;

/*! \brief A* representation of a moving object
 *
 *  A* representation of a moving object
 */
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
