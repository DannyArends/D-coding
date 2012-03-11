/**********************************************************************
 * \file src/game/server/gameserver.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module game.server.gameserver;

import core.stdinc;
import core.typedefs.types;
import core.typedefs.webtypes;

import web.server;
import game.tilemap;
import game.server.clientcommand;
import game.server.usermanagment;
import game.server.clienthandler;

T[] load(T)(string dir = "data/maps/", string ext = ".map"){
  T[] items;
  foreach(string e; dirEntries(dir, SpanMode.breadth)){
    if(isFile(e)){
      if(e.indexOf(ext) > 0){
        writefln(e);
        e = e[e.indexOf(dir)+dir.length..$];
        T item = new T(dir, e);
        if(item.status == FileStatus.OK) items ~= item;
      }
    }
  }
  writefln("[SERVER] Loaded %d  %s items from %s",items.length, ext, dir);
  return items;
}

class GameServer : Server!ClientHandler{
  private:
    UserManagment  usermngr;
    TileMap[]      maps;
  public:
    this(){
      super();
      maps = load!TileMap();
      usermngr = new UserManagment();
    }
    
    void shutdown(){ 
      super.shutdown();
      foreach(TileMap m; maps){
        m.save();
      }
    }
}
