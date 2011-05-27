/**
 * \file textreader.D
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
 * Contains: LargeFileScanner
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

import xbinaryreader;

class TextReader{
  string buffer;
  string[] entities;
  uint buffersize = BUFFERSIZE.BUFFER_16KB;
  long rowindex=0;
  long colindex=0;
    
  void setBufferSize(uint customsize){
    buffersize=customsize;
  }
  
  void setBufferSize(BUFFERSIZE bsize){
    buffersize=bsize;
  }
  
    /*
  * Loads a single item in a tab separated file to memory.
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
    writef("Filesize %d: %d buffers %d lines, %d tabs in %d\n", filesize, buffercount, linecount, tabscount, (t1-t0));
    return 1;
  }
    
  /*
  * Loads a single item from a tab separated file to memory.
  *
  * @param filename to load
  * @return Number of buffers needed to read in the entire file
  */
  string loadToMemory(string filename, long row, long col){
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
 
  bool loadPartial(string filename,string outname,long[] lines){
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

  bool load(int datasetID, string filename){
    auto f = new File(filename,"rb");
    auto fout = new File("out.txt","wb");
    ulong linecount = 0;
    ulong entitycount = 0;   
    
    if(isfile(filename)){
      writefln("Filesize: %d", getSize(filename));
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
