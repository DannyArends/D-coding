/******************************************************************//**
 * \file src/game/player.d
 * \brief A user that is playing
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.player;

import core.stdinc, core.typedefs.types, core.typedefs.location;
import core.typedefs.color, core.terminal;
import game.engine, game.structures, game.tilemap;

mixin(GenOutput!("USR", "Green"));

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
        wUSR("Inventory found");
        currentline++;
        while(currentline < lines.length){
          if(chomp(lines[currentline]) == "# --- Data inventory end"){
            wUSR("Done with inventory");
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
    wUSR("Done parsing player file: '%s'",filename);
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
  
  void offline(){ _online=false; }
  
  @property{
    bool     online(bool on = false){if(on){ _online = on; } return _online;}
    ref GameUser info(){ return userinfo; }
    string   name(){ return userinfo.name; }
    string   password(){ return userinfo.pass; }
    string   lastloggedin(string time = ""){
        if(time != "") userinfo.lastloggedin = time;
        return userinfo.lastloggedin; 
      }
  }
  
  private:
    bool         _online = true;
    GameUser     userinfo;
    FileStatus   _status = FileStatus.NO_SUCH_FILE;
}
