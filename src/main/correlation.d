/**********************************************************************
 * \file src/main/correlation.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.conv;
import core.time;
import std.datetime;

import core.arrays.search;
import core.io.xbin.reader;
import core.io.iofunctions;
import core.io.textreader;
import plugins.regression.statistics;

void print_usage(){
  writeln("   Usage: correlation in.csv buffersize");
  writeln("   Supported buffersize: 2mb, 4mb, 16mb, 64mb, 256mb");
  writeln("   e.g.: correlation ./test/data.csvr 2mb");
}

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
    uint individuals[] = range(1,15);
    auto data1 = reader.loadSubMatrix!double(args[1],individuals);
    writeln("Correlation algorithm 1");
    auto t1 = Clock.currTime();
    foreach(ref a; data1){
      foreach(ref b; data1){ 
        correlation_v2!double(a,b);
      }
      writeln(".");
    }
    auto t2 = Clock.currTime();
    writef("\nFast %d\n", (t2-t1));
    writeln("Correlation algorithm 2");
    auto t3 = Clock.currTime();
    foreach(ref a; data1){
      foreach(ref b; data1){ 
        correlation_v2!double(a,b);
      }
      writeln(".");
    }
    auto t4 = Clock.currTime();
    writef("\nSlow %d\n", (t4-t3));
  }else{
    print_usage();
  }
}
