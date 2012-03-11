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
import game.player;
import game.tilemap;
import game.server.clientcommand;
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
    Player[]  users;
    TileMap[] maps;
    
  public:
    this(){
      super();
      users = load!Player("data/users/",".usr");
      maps = load!TileMap("data/maps/",".map");
    }
    
    bool createUser(string name, string pass){
      if(userExists(name)) return false;
      users ~= new Player("data/users/",name ~ ".usr", name, pass);
      return true;
    }
    
    bool validatePass(string name, string pass){
      if(!userExists(name)) return false;
      if(users[getUserSlot(name)].password == pass) return true;
      return false;
    }
    
    void shutdown(){ 
      super.shutdown();
      foreach(TileMap m; maps){ m.save(); }
      foreach(Player p; users){ p.save(); }
    }
    
    uint getUserSlot(string name){
      foreach(uint cnt, Player p; users){
        if(toLower(p.name) == toLower(name)) return cnt;
      }
      return -1;
    }
    
    bool userExists(string name){
      foreach(Player p; users){
        if(toLower(p.name) == toLower(name)) return true;
      }
      return false;
    }
}
