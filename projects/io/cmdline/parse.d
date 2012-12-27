/******************************************************************//**
 * \file src/io/cmdline/parse.d
 * \brief Parse the commandline options into a Settings structure
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jan, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.cmdline.parse;

import std.stdio, std.string, std.conv;

struct S(T){
  string name;
  string description;
  T      value;
}

struct Scontainer{
  S!bool[]   booleans;
  S!uint[]   integers;
  S!string[] strings;
}

struct Settings{
  void load(Scontainer opt){
    this.opt = opt;
  }
  
  bool displayHelp(){
    if(getBool("--help")){
      foreach(S!bool s; opt.booleans){ writeln("  " ~ s.name[0] ~ "[" ~ s.name[1..3] ~"]" ~ s.name[3..$] ~ " - " ~ s.description); }
      foreach(S!uint s; opt.integers){ writeln("  " ~ s.name[0] ~ "[" ~ s.name[1..3] ~"]" ~ s.name[3..$] ~ " - " ~ s.description); }
      foreach(S!string s; opt.strings){ writeln("  " ~ s.name[0] ~ "[" ~ s.name[1..3] ~"]" ~ s.name[3..$] ~ " - " ~ s.description); }
      return true;
    }
    return false;
  }
  
  uint getInt(string name){
    foreach(int cnt, S!uint s; opt.integers){
      if(name==s.name){
        return s.value;
      }
    }
    writeln(" - ERROR: Unknown parameter requested: ",name);
    return -1;
  }
  
  bool getBool(string name){
    foreach(int cnt, S!bool s; opt.booleans){
      if(name==s.name){
        return s.value;
      }
    }
    writeln(" - ERROR: Unknown parameter requested: ",name);
    return false;
  }
  
  string getString(string name){
    foreach(int cnt, S!string s; opt.strings){
      if(name==s.name){
        return s.value;
      }
    }
    writeln(" - ERROR: Unknown parameter requested: ",name);
    return "";
  }
  Scontainer opt;
}

import std.getopt;

Settings parseCmd(string[] args){
  Settings settings;
  Scontainer opt;

  bool help = false;
  bool verbose = false;

  getopt(args, "help|h", &help
             , "verbose|v", &verbose);

  opt.booleans ~= S!bool("--help"         ,"Show the help file", help);
  opt.booleans ~= S!bool("--verbose"      ,"Verbose mode", verbose);
  settings.load(opt);
  return settings;
}
