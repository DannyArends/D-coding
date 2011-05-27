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

class TextReader{
  string buffer;
  string[] entities;
  
  T[][] loadSubMatrix(T)(string filename,uint[] columns){
    auto f = new File(filename,"rb");
    auto data = new T[][columns.length-1];
    ulong linecount = 0;
    if(isfile(filename)){
      writefln("Filesize: %d", getSize(filename));
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
