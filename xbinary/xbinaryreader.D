/**
 * \file xbinaryreader.D
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends, Joeri v/d Velde, Pjotr Prins, Karl W. Broman, Ritsert C. Jansen
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: BinaryReader
 * 
 **/

import std.math; 
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;
import std.datetime;
import core.time;

void main(string[] args){
  auto ret = new BinaryScanner();
  ret.loadToMemory(args[1]);
}

class BinaryReader{
  ubyte[] buffer;
    
  int loadToMemory(string filename){
    if(!exists(filename) || !isfile(filename)) return -1;
    auto f = new File(filename,"rb");
    ubyte[] buff = new ubyte[1024];
    
    auto t0 = Clock.currTime();
    auto t1 = Clock.currTime();
    while(f.rawRead(buff)){
      //writef("%s",buff);
      writef("%d\n",countchars(cast(string)buff,"\n"));
    }
    t1 = Clock.currTime();
    writef("%d\n",(t1-t0));
    return 0;
  }
  /**
   *
   * Unit test for the binary_reader class
   *       
   **/
  unittest{
  
  }
}
