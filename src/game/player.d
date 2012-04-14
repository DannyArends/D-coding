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
import game.engine;
import game.structures;
import game.tilemap;

class Player : GameObject{
  public:
    this(string data){ super(data); }

    this(string dir, string name, string username = "", string password = "", string servertime = ""){
      super(dir,name);
      if(!exists(filepath) || !isFile(filepath)){
        userinfo.name         = username;
        userinfo.pass         = password;
        userinfo.location[0]  = new Location(0,0,0);
        userinfo.location[1]  = new Location(0,0,0);
        userinfo.map          = new TileMap("data/maps/", name);
        userinfo.created      = servertime;
        userinfo.lastloggedin = servertime;
        save();        //Creating a new player
      }
    }
  
    @property FileStatus status(){ return _status; }
  
  void parseGameItem(string buffer){
    auto fields = split(buffer,"\t");
    if(fields.length == 2){ }
  }
  
  override void fromString(string data){
    string[] lines = splitLines(data);
    userinfo.name = chomp(lines[0]);
    userinfo.pass = chomp(lines[1]);
    userinfo.location[0] = new Location(chomp(lines[2]));
    userinfo.location[1] = new Location(chomp(lines[3]));
    userinfo.map = new TileMap("data/maps/", chomp(lines[4]));
    userinfo.created = chomp(lines[5]);
    userinfo.lastloggedin = chomp(lines[6]);
    int currentline = 7;
    while(currentline < lines.length){
      if(chomp(lines[currentline]) == "# --- Data inventory begin"){
        writeln("[USR] inventory definitions");
        currentline++;
        while(currentline < lines.length){
          if(chomp(lines[currentline]) == "# --- Data inventory end"){
            writeln("[USR] inventory done");
            _status = FileStatus.OK;
            break;
          }
          if(lines[currentline][0] == '#') continue;
          parseGameItem(chomp(lines[currentline]));
          currentline++;
        }
      }
      currentline++;
    }
    writefln("Done player-file: %s",filename);
  }

  string asLimited(){
    string s;
    s ~= userinfo.name     ~ "\n" ~ userinfo.pass ~ "\n";
    s ~= to!string(userinfo.location[0]) ~ "\n" ~ to!string(userinfo.location[1]) ~ "\n";
    s ~= userinfo.map.name ~ "\n";
    s ~= userinfo.created  ~ "\n" ~ userinfo.lastloggedin ~ "\n";
    s ~= "# --- Data clothing begin" ~ "\n";
    foreach(GameItem clo; userinfo.clothing){ s ~= to!string(clo) ~ "\n"; }
    s ~= "# --- Data clothing end\n";
    return s;
  }

  override string asString(){
    string s = asLimited();
    s ~= "# --- Data inventory begin\n";
    foreach(GameItem inv; userinfo.inventory){ s ~= to!string(inv) ~ "\n"; }
    s ~= "# --- Data inventory end\n";
    s ~= "# --- Data storage begin\n";
    foreach(GameItem sto; userinfo.storage){ s ~= to!string(sto) ~ "\n"; }
    s ~= "# --- Data storage end\n";
    s ~= "# --- Data assets begin\n";
    foreach(GameObj asset; userinfo.assets){ s ~= to!string(asset) ~ "\n"; }
    s ~= "# --- Data assets end\n";
    return s;
  }
  
  @property{
    ref GameUser info(){ return userinfo; }
    string   name(){ return userinfo.name; }
    string   password(){ return userinfo.pass; }
    string   lastloggedin(string time = ""){
        if(time != "") userinfo.lastloggedin = time;
        return userinfo.lastloggedin; 
      }
  }
  
  private:
    GameUser     userinfo;
    FileStatus   _status = FileStatus.NO_SUCH_FILE;
}
