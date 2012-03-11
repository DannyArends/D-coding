/**********************************************************************
 * \file src/game/structures.d
 * \brief Game structure definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.structures;

import std.stdio;
import std.conv;
import core.memory;
import core.typedefs.location;

struct GameObj{
  uint           obj_uid;
  uint           creator_uid;
  Location       location;
}

struct GameItem{
  uint           item_uid;
  uint           creator_uid;
  bool           wearable;
}

struct GameUser{
  uint           user_uid;
  string         name;
  string         password;
  Location       location;
  GameItem[12]   clothing;
  GameItem[25]   inventory;
  GameItem[500]  storage;
  GameObj[300]   assets;
}
