/**********************************************************************
 * \file src/game/player.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.player;

import core.stdinc;
import core.typedefs.types;
import core.typedefs.location;
import core.typedefs.color;
import game.structures;
import game.tilemap;

class Player{
  public:  
    this(string dir, string name, string username = "", string password = ""){
      filename = dir ~ name;
      if(!exists(filename) || !isFile(filename)){
        //Creating a new player
        userinfo.name     = username;
        userinfo.pass     = password;
        userinfo.location = new Location(0,0,0);
        userinfo.map      = new TileMap("data/maps/", name);
        save();
      }else{
        //load the player from file
        load();
        userinfo.map      = new TileMap("data/maps/", name);
      }
    }
  
    @property FileStatus status(){ return _status; }

    void load(){
      writefln("Opening player-file: %s",filename);
      auto fp = new File(filename,"rb");
      string buffer;
      fp.readln(buffer);
      userinfo.name = chomp(buffer);
      fp.readln(buffer);
      userinfo.pass = chomp(buffer);
      while(fp.readln(buffer)){
        if(chomp(buffer) == "# --- Data inventory begin"){
          writeln("[USR] inventory definitions");
          while(fp.readln(buffer)){
            if(chomp(buffer) == "# --- Data inventory end"){
            writeln("[USR] inventory done");
            _status = FileStatus.OK;
            break;
          }
          if(buffer[0] == '#') continue;
          parseGameItem(chomp(buffer));
        }
      }
    }
    fp.close();
    writefln("Done player-file: %s",filename);
  }
  
  void parseGameItem(string buffer){
    auto fields = split(buffer,"\t");
    if(fields.length == 2){ }
  }
  
  void save(){
    writefln("Saving player-file: %s",filename);
    auto fp = new File(filename,"wb");
    fp.writeln(userinfo.name);
    fp.writeln(userinfo.pass);
    fp.writeln(userinfo.location);
    fp.writeln(userinfo.map);
    fp.writeln("# --- Data clothing begin");
    foreach(GameItem clo; userinfo.clothing){ fp.writeln(clo); }
    fp.writeln("# --- Data clothing end");
    fp.writeln("# --- Data inventory begin");
    foreach(GameItem inv; userinfo.inventory){ fp.writeln(inv); }
    fp.writeln("# --- Data inventory end");
    fp.writeln("# --- Data storage begin");
    foreach(GameItem sto; userinfo.storage){ fp.writeln(sto); }
    fp.writeln("# --- Data storage end");
    fp.writeln("# --- Data assets begin");
    foreach(GameObj asset; userinfo.assets){ fp.writeln(asset); }
    fp.writeln("# --- Data assets end");
    fp.close();
    writefln("Done player-file: %s",filename);
  }
  
   @property string name(){ return userinfo.name; }
   @property string password(){ return userinfo.pass; }
  
  private:
    GameUser     userinfo;
    string       filename;
    FileStatus   _status = FileStatus.NO_SUCH_FILE;
}
