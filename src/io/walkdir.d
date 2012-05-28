/******************************************************************//**
 * \file src/io/walkdir.d
 * \brief Walkdir for entropy function
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.walkdir;

import std.stdio, std.math, std.file, std.path, std.string, std.conv;
import std.getopt, core.memory, core.terminal, core.numbers.entropy;
import core.arrays.ranges, core.arrays.matrix;

string[] forbidden_names = ["pagefile.sys","System Volume Information","CONFIG.SYS","","RECYCLER"];

bool valid_name(string sn){
  if(sn[0] == '.') return false;
  foreach(string name; forbidden_names){ if(name == sn) return false; }
  return true;
}

ulong[2] walkdir(File* fp, string dir = ".", ulong cnts[2] = [0, 0], uint depth = 4){
  if(depth<=0) return cnts;
  string sn;
  foreach(string fn; dirEntries(dir, SpanMode.shallow)){
    sn = fn[lastIndexOf(fn,"\\")+1..$];
    if(valid_name(sn)){
      if(isDir(fn)){
        if(cnts[1] % 100 == 0){
          MSG("In %s, done: %s files / %s dirs", fn[0..getI(18,fn)], cnts[0], cnts[1]);
        }
        cnts[1]++;
        cnts = walkdir(fp, dir ~ "\\" ~ sn, cnts,(depth-1));
      }
      if(isFile(fn) && getSize(fn) > 0){
        if(dir != "." && lastIndexOf(sn,".") > 0){
          entropy!ushort(fn,fp); 
          cnts[0]++; 
        }
        //writefln("File: %s",fn);
      }
    }
  }
  return cnts;
}
