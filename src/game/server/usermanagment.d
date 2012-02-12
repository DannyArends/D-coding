module game.server.usermanagment;

import std.array;
import std.stdio;
import std.datetime;
import core.time;
import std.conv;
import std.file;

import core.typedefs.basictypes;
import core.typedefs.color;

enum Race { RBC, WBC, FUNGUS, YEAST, BACTERIUM };

class UserManagment{
  
  bool userExists(string name){
    string buffer;
    if(!exists(userManagmentFile) || !userManagmentFile.isFile) return false;
    auto   f  = new File(userManagmentFile,"rb");
    uint cnt = 0;
    while(f.readln(buffer)){
      string[] entities = buffer.split("\t");
      writeln(entities[1]);
      if(entities[1] == name) return true;
    }
    return false;
  }
  
  UserInfo*  createUser(string name, string password){
    if(!userExists(name)){
      uint id = getUniqueId();
      writef("New user: %d '%s'", id, name);
      UserInfo* u = new UserInfo(id, name, password);
      online_users ~= (*u);
      writeln(", empty user created");
      saveNewUser(u);
      writeln("Saved.");
      return u;
    }
    return null;
  }
  
  UserInfo*  loginUser(string name, string password){
    if(userExists(name)){
      if(isLoggedOn(name)==-1){
        if(password==getUserPassword(name)){
          UserInfo* u = loadUser(name);
          online_users ~= (*u);
          return u;
        }else{
          writeln("Wrong password for user: " ~ name);
        }
      }else{
        writeln("User already logged on: " ~ name);
      }
    }else{
      writeln("User doesn't exist: " ~ name);
    }
    return null;
  }  
  
  bool saveUser(UserInfo* user){
    if(!exists(userDir)) mkdir(userDir);
    auto f  = new File(userDir ~ "/" ~ userprefix ~ user.name,"wb");
    f.write(user.userIDString());
    f.writeln(user.creationTime);
    f.writeln(user.location.toString());
    f.writeln(user.look.toString());
    f.writeln(user.skills.toString());
    f.close();
    writeln("Saved user statistics: " ~ user.name);
    return true;
  }
  
  void userOffline(string name){
    int index = isLoggedOn(name);
    if(index != -1){
      UserInfo[] new_online_users;
      for(auto x=0;x<online_users.length;x++){
       if(x != index)  new_online_users ~= online_users[x];
      }
      online_users = new_online_users;
    }
    writeln("No such user online: " ~ name);
  }
  
private:
  string     userManagmentFile = "data/users.txt";
  string     userDir = "data/users";
  string     userprefix = "USER_";
  UserInfo[] online_users;
  
  int isLoggedOn(string name){
    foreach(int cnt, UserInfo user; online_users){
      if(user.name==name) return cnt;
    }
    return -1;
  }
  
  uint       getUniqueId(){
    string buffer;
    if(!exists(userManagmentFile) || !userManagmentFile.isFile) return 0;
    auto   f  = new File(userManagmentFile,"rb");
    uint   cnt = 0;
    while(f.readln(buffer)){
      cnt++;
    }
    return (cnt+1);
  }
  
  UserInfo*  loadUser(string name){
    string buffer;
    string[] entities;
    auto   f  = new File(userDir ~ "/" ~ userprefix~name,"rb");
    f.readln(buffer);
    entities = buffer.split("\t");
    UserInfo* u = new UserInfo(to!uint(entities[0]), entities[1], entities[2]);
    f.readln(u.creationTime);
    f.readln(buffer);
    u.location.fromString(buffer);
    f.readln(buffer);
    u.look.fromString(buffer);
    f.readln(buffer);
    u.skills.fromString(buffer);
    f.close();
    writeln("Loaded user: " ~ name);
    return u;
  }
  
  string    getUserPassword(string name){
    string buffer;
    auto   f  = new File(userManagmentFile,"rb");
    while(f.readln(buffer)){
      string[] entities = buffer.split("\t");
      if(entities[1] is name) return entities[2];
    }
    return null;   
  }
  
  bool      saveNewUser(UserInfo* user){
    if(!exists(userManagmentFile) || !userManagmentFile.isFile){
      std.file.write(userManagmentFile,user.userIDString());
    }else{
      append(userManagmentFile,user.userIDString());
    }
    writeln("Saved new login credentials");
    return saveUser(user);
  }
};

struct XZLocation{
  int[2] xz;
};

struct UserInfo{
  this(uint id, string name, string password){
    this.id=id;
    this.name=name;
    this.password=password;
    this.creationTime = Clock.currTime().toISOExtString();
    location = new UserLocation();
    look = new Looks();
    skills = new Skills();
  }
  
  string userIDString(){
    return to!string(id) ~ "\t" ~ to!string(name) ~ "\t" ~ to!string(password) ~ "\n";
  }
  
  uint          id;
  string        name;
  string        password;
  string        creationTime;
  UserLocation* location;
  Looks*        look;
  Skills*       skills;
};

struct Looks{
  this(Race race = Race.RBC){
    this.race =race;
    color1 = new Color(1,0,0);
    color2 = new Color(0,1,0);
    color3 = new Color(0,0,1);
  }
  Race  race;        //Race
  Color color1;      //UserDefined Colors
  Color color2;      //UserDefined Colors
  Color color3;      //UserDefined Colors
  string toString(){
    string looks = to!string(race) ~ "\t";
    looks = looks ~ to!string(color1) ~ "\t"~ to!string(color2) ~ "\t" ~ to!string(color3);
    return looks;
  }
  
  void fromString(string location){
    string[] entities = location.split("\t");
    this.race = to!Race(entities[0]);
    this.color1 = new Color(stringToArray!ubyte(entities[1]));
    this.color2 = new Color(stringToArray!ubyte(entities[2]));
    this.color3 = new Color(stringToArray!ubyte(entities[3]));
  }
};

struct UserLocation{
  this(uint mapid = 0){
    this.mapid = mapid;
    xyz        = [10.0,0.0,5.0];
    heading    = 1;
  }
  uint         mapid;        //Which map are we on
  double       xyz[3];       //Actual location in double (rounded x,z = tile)
  int          heading;      //Which way are we looking
  int          req_xz[2];    //The tile we want to move to
  int          req_heading;  //The way we want to look
  XZLocation[] cur_path;     //The current path we're traveling on
  
  string toString(){
    string location = to!string(mapid) ~ "\t";
    location = location ~ to!string(xyz[0]) ~ "," ~ to!string(xyz[1]) ~"," ~ to!string(xyz[2]) ~ "\t" ~ to!string(heading);
    return location;
  }
  
  void fromString(string location){
    string[] entities = location.split("\t");
    this.mapid = to!uint(entities[0]);
    this.xyz = stringToArray!double(entities[1]);
    this.heading = to!uint(entities[2]);
  }
};

struct ItemInfo{
  uint id;         //ItemID
  uint qty;        //Quantity
};

struct Skill{
  string name;
  ulong  xp;
  uint   bonus;
  
  string toString(){
    return name ~ "\t" ~ to!string(xp) ~ "\t"~ to!string(bonus);
  }
  
  string fromString(string location){
    string[] entities = location.split("\t");
    this.name = entities[0];
    this.xp = to!ulong(entities[1]);
    this.bonus = to!uint(entities[2]);
    string collector;
    for(auto x = 3;x<location.length;x++){
      collector ~= entities[x];
    }
    return collector;
  }
};

struct Skills{
  this(uint hack = 0){
    skills ~= Skill("Attack",1024,0);
    skills ~= Skill("Defence",1024,0);
    skills ~= Skill("Absorption",0,0);
    skills ~= Skill("Homeostasis",0,0);
  }
  Skill[] skills;
  Skill overall(){
    ulong xp = 0;
    foreach(Skill s;skills){
      xp += s.xp;
    }
    return Skill("Overall",xp,0);
  }
  
  string toString(){
    string skillsStr = "";
    foreach(int cnt,Skill s;skills){
      if(cnt > 0) skillsStr ~= "\t"; 
      skillsStr ~= s.toString();
    }
    return skillsStr;
  }
  
  void fromString(string location){
    while(location.length > 0){
      Skill s;
      location = s.fromString(location);
      skills ~= s;
    }
  }
}

uint xptolvl(ulong xp){
  ulong remainder       = xp;
  int   xp_to_next_lvl  = 1024;
  uint  lvl             = 0;
  while(remainder > xp_to_next_lvl){
    remainder -= xp_to_next_lvl;
    xp_to_next_lvl *= 2;
    lvl++;
  }
  return lvl;
}