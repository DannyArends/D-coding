/******************************************************************//**
 * \file src/game/games/movementserver.d
 * \brief Movement server class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.server.movementserver;

import core.stdinc, core.terminal, core.typedefs.types;
import core.typedefs.location, core.typedefs.webtypes;
import game.search, game.tilemap, game.player;
import game.server.gameserver;

alias core.thread.Thread Thread;

class MovementServer : Thread{

  this(GameServer server){
   _server=server;
   super(&run);
  }

  void run(){
    while(_server.online){
      Player[] players = _server.getUsers();
      for(size_t x = 0; x < players.length; x++){
        if(players[x].online){
          Location cur = players[x].info.location[0];
          Location req = players[x].info.location[1];
          TileMap map = players[x].info.map;
          if(cur.x != req.x || cur.y != req.y){
            if(req.x < map.x && req.y < map.y && req.x >= 0 && req.y >= 0){
              MSG("Player who needs movement detected");
              AStarSearch search = new AStarSearch(to!int(cur.x),to!int(cur.z),to!int(req.x),to!int(req.y),players[x].info.map);
              long wait = search.searchPath(200);
              if(wait > 0 && wait < 200) Thread.sleep( dur!("msecs")( wait ) );
              MSG("Path after %s ms -> %s", wait, search.getPath());
            }
          }
        }
      }
      //writeln("[ S ] Gonna sleep ",players.length);
      Thread.sleep(dur!("msecs")( 200 ));
    }
     WARN("Movement server stopped");
  }

private:
  GameServer _server;
}
