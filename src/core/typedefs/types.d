/**********************************************************************
 * \file src/core/typedefs/types.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.types;

import std.stdio;
import std.file;
import std.conv;
import std.string;
import std.random;
import core.memory;

T[] stringArrayToType(T)(string[] entities){
  T[] rowleveldata;
  for(auto e=0;e < entities.length; e++){
    rowleveldata ~= to!T(entities[e]);
  }
  return rowleveldata;
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
  int[] mytime  = [0,0,0,1,1,1];
  
  void load(string filename = "ST.save"){
    if(!exists(filename)){
      writefln("[T T] Not found: %s",filename);    
    }else{
      auto fp = new File(filename,"rb");
      string buffer;
      int cnt=0;
      fp.readln(buffer);
      buffer = chomp(buffer);
      mytime.length=0;
      string[] entities = buffer.split("\t");
      foreach(string e; entities){mytime ~= to!int(e); }
      fp.close();
      writefln("[ G ] %s loaded", filename);
    }
  }
  
  void save(string filename = "ST.save"){
    auto fp = new File(filename,"wb");
    string buffer = "";
    int cnt = 0;
    foreach(int c; mytime){
      if(cnt >= 1) buffer ~= "\t";
      buffer ~= to!string(c); 
      cnt++;
    }
    fp.writeln(buffer);
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
      break;
      case 1:
        return '!';
      break;
      case 2:
        return '@';
      break;
      case 3:
        return '#';
      break;      
      case 4:
        return '$';
      break;
      case 5:
        return '%';
      break;
      case 6:
        return '^';
      break;
      case 7:
        return '&';
      break;
      case 8:
        return '*';
      break;
      case 9:
        return '(';
      break;
      default:
      break;
    }
    return to!char(toUpper(to!string(c)));
  }catch{
    return to!char(toUpper(to!string(c)));
  }
}
