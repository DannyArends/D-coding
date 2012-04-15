/**********************************************************************
 * \file src/game/server/movementserver.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module game.server.movementserver;

import core.stdinc;
import core.typedefs.types;
import core.typedefs.location;
import core.typedefs.webtypes;

import game.search;
import game.tilemap;
import game.server.gameserver;
import game.player;

alias core.thread.Thread Thread;

class MovementServer : Thread{

  this(GameServer server){
   _server=server;
   super(&run);
  }

  void run(){
    while(_server.online){
      Player[] players = _server.getUsers();
      for(int x =0;x < players.length;x++){
        if(players[x].online){
          Location cur = players[x].info.location[0];
          Location req = players[x].info.location[1];
          TileMap map = players[x].info.map;
          if(cur.x != req.x || cur.y != req.y){
            if(req.x < map.x && req.y < map.y && req.x >= 0 && req.y >= 0){
              writeln("[MOV] Player who needs movement detected");
              AStarSearch search = new AStarSearch(to!int(cur.x),to!int(cur.z),to!int(req.x),to!int(req.y),players[x].info.map);
              long wait = search.searchPath(200);
              if(wait > 0 && wait < 200) Thread.sleep( dur!("msecs")( wait ) );
              writeln("[PATH] ",wait," -> ", search.getPath());
            }
          }
        }
      }
      //writeln("[ S ] Gonna sleep ",players.length);
      Thread.sleep(dur!("msecs")( 200 ));
    }
     writeln("[SEVERE] MOVEMENT DIED");
  }

private:
  GameServer _server;
}
