/**********************************************************************
 * \file src/main/fileloader.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.conv;

import core.arrays.search;
import core.io.xbin.reader;
import core.io.iofunctions;
import core.io.textreader;

void print_usage(){
  writeln("   Usage: fileloader in.csv buffersize [start-col] [end-col]");
  writeln("   Supported buffersize: 2mb, 4mb, 16mb, 64mb, 256mb");
  writeln("   e.g.: fileloader.exe data/csv/test.csv 2mb");
  writeln("   e.g.: fileloader.exe data/csv/test.csv 4mb 1 23");
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
    if(reader.describeFile(args[1]) && args.length >= 5){
      stdout.flush();
      string[][] item = reader.applyTo!string(args[1],&singleItem!string,to!long(args[3]),to!long(args[4]));
      writef("    - Single item: test: %s\n",item[0][0]);
      stdout.flush();
      string[][] row_items = reader.applyTo!string(args[1],&singleRow!string,to!long(args[3]));
      writef("    - Row test: %s %s %s\n",row_items[0][0],row_items[0][1],row_items[0][2]);
      stdout.flush();
      string[][] col_items = reader.applyTo!string(args[1],&singleColumn!string,to!long(args[3]));
      writef("    - Column test: %s %s %s\n",col_items[0][0],col_items[0][1],col_items[0][2]);
      stdout.flush();
    }
  }else{
    print_usage();
  }
}
