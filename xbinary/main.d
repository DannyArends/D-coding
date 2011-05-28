/**
 * \file main.d
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
 * Contains: main
 * 
 **/

import std.stdio;
import std.conv;

import xbinaryreader;
import textreader;
import statistics;
import textreader;
import searching;
import iofunctions;
 
void main(string[] args){
  TextReader reader = new TextReader();
  if(args.length > 2){
    switch(args[2]){
      case "2mb"  :reader.setBufferSize(BUFFERSIZE.BUFFER_2MB);break;
      case "4mb"  :reader.setBufferSize(BUFFERSIZE.BUFFER_4MB);break;
      case "16mb" :reader.setBufferSize(BUFFERSIZE.BUFFER_16MB);break;
      case "64mb" :reader.setBufferSize(BUFFERSIZE.BUFFER_64MB);break;
      case "256mb":reader.setBufferSize(BUFFERSIZE.BUFFER_256MB);break;
      default     :reader.setBufferSize(BUFFERSIZE.BUFFER_16KB);break;
    }
  }
  if(reader.describeFile(args[1])){
    stdout.flush();
    string[][] item = reader.applyTo!string(args[1],&singleItem!string,to!long(args[3]),to!long(args[4]));
    writef("single item: test: %s\n",item[0][0]);
    stdout.flush();
    string[][] row_items = reader.applyTo!string(args[1],&singleRow!string,to!long(args[3]));
    writef("row test: %s %s %s\n",row_items[0][0],row_items[0][1],row_items[0][2]);
    stdout.flush();
    string[][] col_items = reader.applyTo!string(args[1],&singleColumn!string,to!long(args[3]));
    writef("col test: %s %s %s\n",col_items[0][0],col_items[0][1],col_items[0][2]);
    stdout.flush();
  }
  //auto reader2 = new TextReader();
  //reader2.loadToMemory(args[1]);

  //auto dataset = new TextReader();
  //uint individuals[] = doRange(19,100);
  //auto data1 = dataset.loadSubMatrix!double(args[1],individuals);
  //foreach(ref a; data1){
  //  foreach(ref b; data1){ 
  //    writef("%f\t", doCorrelation!double(a,b));
  // }
  //  write("\n");
  //}
}
