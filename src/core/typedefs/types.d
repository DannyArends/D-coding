/******************************************************************//**
 * \file src/core/typedefs/types.d
 * \brief Structure and type definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.types;

import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.random;
import core.memory;

enum EventType       { NULL, MOUSE, KEYBOARD, SOUND, GFX2D, GFX3D, CLOCK, NETWORK, QUIT }
enum NetEvent : char { UNKNOWN = 'U', HEARTBEAT = 'H', REGISTER = 'R', LOGIN = 'L', CHAT = 'C', MOVEMENT = 'M', GAME = 'G', OBJECT = 'O', SOUND = 'S', GFX2D = '2', GFX3D = '3'}
enum KeyEventType    { NONE, DOWN, UP  }
enum MouseBtn        { MOVE = 0, LEFT = 1, MIDDLE = 2, RIGHT = 3 }

T[] stringArrayToType(T)(string[] entities){
  T[] rowleveldata;
  for(auto e=0;e < entities.length; e++){
    rowleveldata ~= to!T(entities[e]);
  }
  return rowleveldata;
}

string arrayToString(T)(T[] entities, string sep = ":", bool conv=false){
  string retdata;
  for(auto e=0;e < entities.length; e++){
    if(e != 0) retdata ~= sep;
    if(conv){
      retdata ~= to!char(entities[e]);
    }else{
      retdata ~= to!string(entities[e]);
    }
  }
  return retdata;
}

/*
 * Splits a string by sep, and transforms each element to types of T
 */
T[] stringToArray(T)(string s, string sep= ","){
  string[] entities = s.split(sep);
  return stringArrayToType!T(entities);
}

struct Point{
  int x;
  int y;
  
  this(int x, int y){
    this.x=x;
    this.y=y;
  }
}

struct Size {
  int width;
  int height;
}

struct Bone{
  float   length;
  string  name;
  bool    rotates = false;
  float   ori[4];
  string  objectname;
  Bone[]  bones;
}

struct Figure{
  string name;
  Bone root;
}

struct FPS{
  int   cnt = 0;
  int   fps = 0;
}

enum FileStatus{ 
  NO_SUCH_FILE = -6, 
  FILE_OPEN = -5, 
  READING_FILE = -4, 
  INDEXED_COLOR = -3, 
  MEMORY = -2, 
  COMPRESSED_FILE = -1, 
  OK = 0
}

struct Texture{
  string       name;
  FileStatus   status;
  uint[]       id;
  uint         type;
  uint         width,height,bpp;
  ubyte[]      data;
}

T[] toType(T)(ubyte[] buffer){
  T[] returnbuffer;
  foreach(int i, byte b ; buffer){
    returnbuffer ~= to!T(b);
  }
  return returnbuffer;
}


string toD(int x, int d){
  string s = to!string(x);
  while(s.length < d){
    s = "0" ~ s;
  }
  return s;
}

struct TimeTracker{
  private:
    int[] mytime  = [0,0,0,1,1,1];
  
  public:
    void load(string filename = "ST.save"){
      if(!exists(filename)){
        writefln("[T T] Not found: %s",filename);    
      }else{
        auto fp = new File(filename,"rb");
        string buffer;
        fp.readln(buffer);
        fromString(chomp(buffer));
        fp.close();
        writefln("[ G ] %s loaded", filename);
      }
    }
    
    void fromString(string msg){
      string[] dt = msg.split(" ");
      string[] entities = dt[1].split(":");
      size_t cnt=0;
      for(size_t x = 2; x>=0; x--){mytime[cnt] = to!int(entities[x]); cnt++; }
      entities = dt[0].split("-");
      for(size_t x = 2; x>=0; x--){mytime[cnt] = to!int(entities[x]); cnt++; }
    }
    
    void save(string filename = "ST.save"){
      auto fp = new File(filename,"wb");
      fp.writeln(val);
      fp.close();
      writefln("[ G ] Saved to %s", filename);
    }
    
    void addSecond(){
      mytime[0]++;
      if(mytime[0] > 59){ mytime[1]++; mytime[0]=0; }
      if(mytime[1] > 59){ mytime[2]++; mytime[1]=0; }
      if(mytime[2] > 23){ mytime[3]++; mytime[2]=0; }
      if(mytime[3] > 30){ mytime[4]++; mytime[3]=1; }
      if(mytime[4] > 12){ mytime[5]++; mytime[4]=1; }
    }
    
    @property string val(){
      return  toD(mytime[3],2) ~ "-" ~ toD(mytime[4],2) ~ "-" ~ toD(mytime[5],4) ~ " " ~
              toD(mytime[2],2) ~ ":" ~ toD(mytime[1],2) ~ ":" ~ toD(mytime[0],2);
    }    
    @property string time(){
      return toD(mytime[2],2) ~ ":" ~ toD(mytime[1],2) ~ ":" ~ toD(mytime[0],2);
    }
    @property string day(){
      return  toD(mytime[3],2) ~ "-" ~ toD(mytime[4],2) ~ "-" ~ toD(mytime[5],4);
    }
}

/*
 * Transforms a character to its value when SHIFT is pressed
 * Based on US-101 keyboard
 */
char toShiftChar(char c){
  try{
    switch(to!int(to!string(c))){
      case 0:
        return ')';
      case 1:
        return '!';
      case 2:
        return '@';
      case 3:
        return '#';
      case 4:
        return '$';
      case 5:
        return '%';
      case 6:
        return '^';
      case 7:
        return '&';
      case 8:
        return '*';
      case 9:
        return '(';
      default: break;
    }
    return to!char(toUpper(to!string(c)));
  }catch{
    return to!char(toUpper(to!string(c)));
  }
}
