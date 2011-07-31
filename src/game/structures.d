module game.structures;

import std.stdio;
import std.conv;
import core.memory;

struct GameLoc{
  uint           map_uid;
  uint           x;
  uint           y;
}

struct GameObj{
  uint           obj_uid;
  uint           creator_uid;
  GameLoc        location;
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
  GameLoc        location;
  GameItem[12]   clothing;
  GameItem[25]   inventory;
  GameItem[500]  storage;
  GameObj[300]   assets;
}
