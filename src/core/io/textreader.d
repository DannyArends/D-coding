/**
 * \file textreader.d
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
 * Contains: TextReader
 * 
 **/
module core.io.textreader;
 
import std.math; 
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;
import std.datetime;
import core.time;
import core.vararg;

import core.io.xbin.reader;
import core.io.iofunctions;

class TextReader{
  string buffer;
  string[] entities;
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
  * Apply to a tab separated file (any size).
  *
  * @param filename to load
  * @return Number of buffers needed to read in the entire file
  */
  T[][] applyTo(T)(string filename, T[][] function(T[][],string,long,long,long,long) apply, ...){
    T[][] dataslice = null;
    long rindex=0;
    long cindex=0;
    for(int i = 0; i < _arguments.length; i++){
      if (_arguments[i] == typeid(long) && i==0){
        rindex = va_arg!(long)(_argptr);
        debug writefln("\trindex: %d", rindex);
      }
      if (_arguments[i] == typeid(long) && i==1){
        cindex = va_arg!(long)(_argptr);
        debug writefln("\tcindex:%d", cindex);
      }
    }
    long rowindex=0;
    long colindex=0;
  
    if(!exists(filename) || !isfile(filename)) return null;
    uint filesize = cast(uint)getSize(filename);
    long linecount=0;
    ubyte[] inputbuffer = new ubyte[buffersize];
    
    auto f = new File(filename,"rb");
    auto t0 = Clock.currTime();
    long buffercount = 0;
    long tabscount = 0;
    T[][] temp;
    while(f.rawRead(inputbuffer)){
      uint tabsi = 0;
      uint tabei = 0;
      foreach(int i,byte b ; inputbuffer){
        switch(cast(char)b){
          case '\n':
            /* Slice up and apply the item at rowindex, colindex*/
            if(rindex==rowindex || cindex==colindex){
            if((temp = apply(dataslice,cast(string)inputbuffer[tabsi..(i-1)].dup, rowindex, colindex, rindex, cindex)) != null){
              dataslice = temp;
              //writef("buffered: %s\n",dataslice);
            }
            }
            tabsi=(i+1);
            rowindex++;
            colindex=0;
            linecount++;
            break;
          case '\t':
            tabscount++;
            tabei=i;
            /* Slice up and apply the item at rowindex, colindex*/
            if(rindex==rowindex || cindex==colindex){
            if((temp = apply(dataslice,cast(string)inputbuffer[tabsi..tabei].dup, rowindex, colindex, rindex, cindex)) != null){
              dataslice = temp;
              //writef("buffered: %s\n",dataslice);
            }
            }
            colindex++;
            tabsi=(i+1); 
            break;
          default: break;
        }
      }
     
      delete inputbuffer; inputbuffer = new ubyte[buffersize];
      auto t2 = Clock.currTime();
      buffercount++;
      debug writef("   Buffer: %d in %d\n", buffercount, (t2-t0));
      stdout.flush();
    }
    auto t1 = Clock.currTime();
    f.close();
    writef("   Filesize %d: %d buffers in %d\n", filesize, buffercount, (t1-t0));
    stdout.flush();
    return dataslice;
  }
  
 /*
  * Prints out a description of a tab separated file (any size).
  *
  * @param filename to load
  * @return Number of buffers needed to read in the entire file
  */
  int describeFile(string filename){
    if(!exists(filename) || !isfile(filename)) return -1;
    uint filesize = cast(uint)getSize(filename);
    long linecount=0;
    ubyte[] inputbuffer = new ubyte[buffersize];
    
    auto f = new File(filename,"rb");
    auto t0 = Clock.currTime();
    long buffercount = 0;
    long tabscount = 0;
    while(f.rawRead(inputbuffer)){
      foreach(int i,byte b ; inputbuffer){
        switch(cast(char)b){
          case '\n':
            linecount++;
            break;
          case '\t':
            tabscount++;
            break;
          default: break;
        }
      }
      delete inputbuffer; inputbuffer = new ubyte[buffersize];
      buffercount++;
    }
    auto t1 = Clock.currTime();
    f.close();
    writef("   Filesize %d: %d buffers %d lines, %d tabs in %d\n", filesize, buffercount, linecount, tabscount, (t1-t0));
    return 1;
  }
    
  /*
  * Loads a single item from a tab separated file (any size) to memory.
  *
  * @param filename to load
  * @return Number of buffers needed to read in the entire file
  */
  string loadToMemory(string filename, long row, long col){
    long rowindex=0;
    long colindex=0;
    if(!exists(filename) || !isfile(filename)) return "No such file";
    uint filesize = cast(uint)getSize(filename);
    long linecount=0;
    ubyte[] inputbuffer = new ubyte[buffersize];
    
    auto f = new File(filename,"rb");
    auto t0 = Clock.currTime();
    long buffercount = 0;
    long tabscount = 0;
    long[] newline_indexes;
    while(f.rawRead(inputbuffer)){
      uint tabsi = 0;
      uint tabei = 0;
      foreach(int i,byte b ; inputbuffer){
        switch(cast(char)b){
          case '\n':
            newline_indexes ~= (buffersize * buffercount) + i; 
            /* Slice up the item at rowindex, colindex*/
            if(row==rowindex && col==colindex) return(cast(string)inputbuffer[tabsi..(i-1)]);
            tabsi=(i+1);
            rowindex++;
            if(rowindex > row) return "No such column"; // Exceptional situation, someone asked for a column that doesn't exist
            colindex=0;
            linecount++;
            break;
          case '\t':
            tabscount++;
            tabei=i;
            /* Slice up the item at rowindex, colindex*/
            if(row==rowindex && col==colindex){
              return(cast(string)inputbuffer[tabsi..tabei]);
            }
            colindex++;
            tabsi=(i+1); 
            break;
          default: break;
        }
      }
      delete inputbuffer; inputbuffer = new ubyte[buffersize];
      buffercount++;
    }
    auto t1 = Clock.currTime();
    f.close();
    return "No such row";
  }
  
 /*
  * Loads a submatrix from a tab separated file (any size) to memory.
  * DEPRECATION REMOVE TODO: Should load via the input buffer to improve performance
  * @param filename to load
  * @param columns to select
  * @return matrix of values cast to the templated type
  */
  T[][] loadSubMatrix(T)(string filename,uint[] columns){
    auto f = new File(filename,"rb");
    auto data = new T[][columns.length-1];
    ulong linecount = 0;
    if(isfile(filename)){
      debug writefln("Filesize: %d", getSize(filename));
      while(f.readln(buffer)){
        entities = buffer.split("\t");
        if(linecount == 0){
          writefln("header: %s", buffer);
        }else{
          for(uint c=0;c < columns.length-1;c++){
            data[c] ~= to!T(entities[columns[c]]);
          }
        }
        linecount++;
      }
      f.close();
      writefln("lines: %d", linecount);
    }
    return data;
  }
  
  void split(string filename,string outname,int number){
    auto f = new File(filename,"rb");
    int outbase=0;
    int cnt=0;
    auto fout = new File(outname~to!string(outbase)~".txt","wb");
    if(isfile(filename)){
      while(f.readln(buffer)){
        fout.write(buffer);
        cnt++;
        if(cnt==number){
          fout.close();
          outbase++;
          fout = new File(outname~to!string(outbase)~".txt","wb");
          cnt=0;
        }
      }
    }
  }
  
 /*
  * Loads a single column from a any size tab separated file to memory.
  * DEPRECATION REMOVE TODO: Should load via the input buffer to improve performance
  * @param filename to load
  * @param columns to select
  * @return matrix of values cast to the templated type
  */
  T[] loadColumn(T)(string filename,uint column){
    auto f = new File(filename,"rb");
    T[] data;
    ulong linecount = 0;
    
    if(isfile(filename)){
      writefln("Filesize: %d", getSize(filename));
      while(f.readln(buffer)){
        entities = buffer.split("\t");
        if(linecount == 0){
          writefln("header: %s", buffer);
        }else{
          data ~= to!T(entities[column]);
        }
        linecount++;
      }
      f.close();
      writefln("lines: %d", linecount);
    }
    return data;
  }
 
  /*
  * Copy the columns [8,15,16,17,18,19,9,10,11,12,13,14] from a any size tab separated file to another files.
  * DEPRECATION: Analysis code for R&W tiling array raw-data
  * @param filename to load
  * @param columns to select
  * @return matrix of values cast to the templated type
  */
  bool copyPartial(string filename,string outname){
    auto f = new File(filename,"rb");
    auto fout = new File(outname,"wb");
    ulong linecount = 0;
    ulong entitycount = 0;
    
    if(isfile(filename)){
      writefln("filesize: %d", getSize(filename));
      while(f.readln(buffer)){
        entities = buffer.split("\t");
        entitycount += entities.length;
        if(linecount == 0) writefln("header: %s", buffer);
        if(linecount == 0) fout.write("id\tprobeset\tseq\tstrand\ttype\t");
        if(linecount == 0) fout.write("Pimp_d_1\tPimp_d_2\tPimp_d_3\tPimp_6_1\tPimp_6_2\tPimp_6_3\t");
        if(linecount == 0) fout.write("Money_d_1\tMoney_d_2\tMoney_d_3\tMoney_6_1\tMoney_6_2\tMoney_6_3\n");
        if(linecount > 0){
          int[] pimp;
          int[] money;
          fout.writef("%d\t%s\t%s\t%s\t%s\t",linecount,entities[3],entities[5],entities[6],entities[7]);
          foreach(int index,uint x; [8,15,16,17,18,19,9,10,11,12,13,14]){
            if(index == 0){
              fout.writef("%d",to!int(entities[x]));
            }else{
              fout.writef("\t%d",to!int(entities[x]));
            }
            if(index > 4){
              pimp ~= to!int(entities[x]);
            }else{
              money ~= to!int(entities[x]);
            }
          }
          fout.write("\n");
        if(linecount % 100000 == 0) writefln("lines: %d, entities: %d", linecount,entitycount);
        }
        linecount++;
      }
      f.close();
      fout.close();
      writefln("lines: %d, entities: %d", linecount,entitycount);
    }
    return true;
  }
 
  /**
   *
   * Unit test for the binary_reader class
   *       
   **/
  unittest{
  
  }
}
