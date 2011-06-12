/**
 * \file xbin/reader.d
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
module core.io.xbin.reader;

import std.math; 
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;
import std.datetime;
import core.time;

enum BUFFERSIZE {BUFFER_16KB = 16_384,BUFFER_2MB = 2_097_152, BUFFER_4MB = 4_194_304,BUFFER_16MB = 16_777_216, BUFFER_64MB = 67_108_864, BUFFER_256MB = 268_435_456}

class BinaryReader{
  ubyte[] buffer;
  uint buffersize = BUFFERSIZE.BUFFER_16KB;
  
 /*
  * Sets the buffersize to a user-defined custom size
  *
  * @param uint with the custom size of the linebuffer
  */
  void setBufferSize(uint customsize){ buffersize=customsize; }
  
 /*
  * Sets the buffersize to a system-predefined size
  *
  * @param BUFFERSIZE of the linebuffer
  */
  void setBufferSize(BUFFERSIZE bsize){ buffersize=bsize; }
  
  /*
  * Load the indexing of our binary format to memory
  *
  * @param filename to load
  * @return Number of buffers needed to read in the entire file
  */
  long loadToMemory(string filename){
    if(!exists(filename) || !isfile(filename)) return -1;
    uint filesize = cast(uint)getSize(filename);
    long linecount=0;
    ubyte[] inputbuffer = new ubyte[buffersize];
    
    auto f = new File(filename,"rb");
    auto t0 = Clock.currTime();
    long buffercount = 0;
    while(f.rawRead(inputbuffer)){
      foreach(int i,byte b ; inputbuffer){
        //Create the indexes for the xbinary format
        
      }
      writef("%d %d\n",inputbuffer.length,buffercount);
      delete inputbuffer; inputbuffer = new ubyte[buffersize];
      buffercount++;
    }
    auto t1 = Clock.currTime();
    
    f.close();
    writef("Filesize %d: took %d buffers in %d\n", filesize, buffercount, (t1-t0));
    return buffercount;
  }
  
  /**
   *
   * Unit test for the binary_reader class
   *       
   **/
  unittest{
  
  }
}
