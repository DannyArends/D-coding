/**
 * \file textreader.D
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
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

import std.math; 
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;

import utils.searching;

  void main(string[] args){
      auto dataset = new TextReader();
      //dataset.load(0, args[1]);
      auto selectedLines =  dataset.loadColumn("mapping_probes.txt",0);
      dataset.write10000Children("exp_ann_tomato.txt","children.txt",selectedLines);
  }

class TextReader{
  ulong entitycount = 0;
  string buffer;
  string[] entities;
  
  long[] loadColumn(string filename,uint column){
    auto f = new File(filename,"rb");
    long[] selectedLines;
    ulong linecount = 0;
    
    if(isfile(filename)){
      writefln("filesize: %d", getSize(filename));
      while(f.readln(buffer)){
        entities = buffer.split("\t");
        entitycount += entities.length;
        if(linecount == 0) writefln("header: %s", buffer);
        if(linecount > 0){
          selectedLines ~= to!long(entities[column]);
          //writefln("line: %d", selectedLines);
        }
        if(linecount % 100000 == 0) writefln("lines: %d, entities: %d", linecount,entitycount);
        linecount++;
      }
      f.close();
      writefln("lines: %d, entities: %d", linecount,entitycount);
    }
    return selectedLines;
  }
  
  bool write10000Children(string filename_in,string filename_out,long[] selected){
    auto f = new File(filename_in,"rb");
    auto fout = new File(filename_out,"wb");
    long writecount =0;
    long linecount =0;
    if(isfile(filename_in)){
      writefln("filesize: %d", getSize(filename_in));
      while(f.readln(buffer)){
        if(linecount == 0){
          writef("%s",buffer);
          fout.writef("%s",buffer);
        }else{
          if(searchArrayBinary(selected,linecount)){
            writecount++;
            fout.writef("%s",buffer);
          }
        }
        if(linecount % 100000 == 0) writefln("lines: %d, wrote: %d", linecount,writecount);
        linecount++;
      }
      f.close();
      fout.close();
      writefln("lines: %d, entities: %d", linecount,entitycount);
    }
    return true;
  }

  bool writeParental(int datasetID, string filename){
    auto f = new File(filename,"rb");
    auto fout = new File("out.txt","wb");
    ulong linecount = 0;
    
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
