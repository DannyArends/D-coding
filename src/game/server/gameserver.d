/******************************************************************//**
 * \file src/game/server/gameserver.d
 * \brief Gameserver class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.server.gameserver;

import core.stdinc;
import core.typedefs.types, core.typedefs.location, core.typedefs.webtypes;

import web.server, core.terminal;
import game.player, game.tilemap, game.structures;
import game.server.clientcommand;
import game.server.clienthandler;
import game.server.movementserver;

T[] load(T)(string dir = "data/maps/", string ext = ".map"){
  T[] items;
  foreach(string e; dirEntries(dir, SpanMode.breadth)){
    if(isFile(e)){
      if(e.indexOf(ext) > 0){
        e = e[e.indexOf(dir)+dir.length..$];
        T item = new T(dir, e);
        if(item.status == FileStatus.OK) items ~= item;
      }
    }
  }
  MSG("Loaded %d  %s items from %s",items.length, ext, dir);
  return items;
}

class GameServer : Server!ClientHandler{
  private:
    string         static_dir = "data/static/";
    string         user_dir   = "data/users/";
    string         maps_dir   = "data/maps/";
    Player[]       users;
    TileMap[]      maps;
    MovementServer movement;
    
  public:
    this(){
      super();
      users = load!Player(user_dir,".usr");
      maps = load!TileMap(maps_dir,".map");
      movement = new MovementServer(this);
      movement.start();
    }
    
    bool createUser(string name, string pass){
      if(userExists(name)) return false;
      int userid = 0;
      string filename = "user" ~ toD(userid,6) ~ ".usr";
      while(exists(user_dir ~ filename)){
        userid++;
        filename = "user" ~ toD(userid,6) ~ ".usr";
      }
      users ~= new Player(user_dir, filename, name, pass, servertime);
      log(this, "New user '" ~ name ~ "' in file: " ~ filename, "server");
      return true;
    }
    
    bool validatePass(string name, string pass){
      if(!userExists(name)) return false;
      if(users[getUserSlot(name)].password == pass){
        return true;
      }
      return false;
    }
    
    override void shutdown(){ 
      super.shutdown();
      foreach(TileMap m; maps){ m.save(); }
      foreach(Player p; users){ p.save(); }
      log(this, " ---- Game server shutdown ----","server");
    }
    
    bool saveUser(string name){
      if(!userExists(name)) return false;
      users[getUserSlot(name)].save();
      return true;
    }

    bool logoutUser(string name){
      if(!userExists(name)) return false;
      users[getUserSlot(name)].save();
      users[getUserSlot(name)].offline();
      log(this, "User '"~name~"' logged out","server");
      return true;
    }

    bool deleteUser(string name){
      if(!userExists(name)) return false;
      string userfile = user_dir ~ users[getUserSlot(name)].filename;
      string mapsfile = maps_dir ~ users[getUserSlot(name)].filename;
      if(exists(userfile)){
        users = users[0..getUserSlot(name)] ~ users[getUserSlot(name)+1..$];
        std.file.remove(userfile);
        if(exists(mapsfile)) std.file.remove(mapsfile);
        log(this, "User '"~name~"' permanently deleted: " ~ userfile,"server");
        WARN("Deleted user files: '%s'",userfile);
        return true;
      }
      return false;
    }
    
    void updateUser(T)(string name, T newvalue, string what){
      static if(is(T == Location)){
        MSG("Updating user requested location");
        users[getUserSlot(name)].info.location[1] = cast(Location)newvalue;
      }
      static if(is(T == TileMap)){
        MSG("Updating user current map");
        users[getUserSlot(name)].info.map = cast(TileMap)newvalue;
        log(this, "User "~name~" changed map", "server");
      }
      static if(is(T == string)){
        switch(what){
          case "name":
            MSG("Updating username %s -> %s", name, newvalue);
            users[getUserSlot(name)].info.name = cast(string)newvalue;
            log(this, "User '"~name~"' changed name to "~ cast(string)newvalue, "server");
          break;
          case "pass":
            MSG("Updating password for user %s",name);
            users[getUserSlot(name)].info.pass = cast(string)newvalue;
            log(this, "User '"~name~"' changed his password", "server");
          break;
          case "lastloggedin":
            MSG("Updating last logged in %s ",name);
            users[getUserSlot(name)].online(true);
            users[getUserSlot(name)].info.lastloggedin = servertime;
          break;
          default:
          WARN("Request to update unknown string in user");
          break;
        }
      }
    }

    uint getUserSlot(string name){
      foreach(uint cnt, Player p; users){
        if(toLower(p.name) == toLower(name)) return cnt;
      }
      return -1;
    }

    Player getPlayer(string name){
      foreach(uint cnt, Player p; users){
        if(toLower(p.name) == toLower(name)) return p;
      }
      return null;
    }
    
    ref Player[] getUsers(){ return users; }

    bool userExists(string name){
      foreach(Player p; users){
        if(toLower(p.name) == toLower(name)) return true;
      }
      return false;
    }
}
