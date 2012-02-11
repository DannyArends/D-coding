/**
 * \file httpreader.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;
import std.conv;

import core.web.httpreader;


void print_usage(){
  writeln("   Usage: httpreader host port page");
  writeln("   e.g.: httpreader www.dannyarends.nl 80 /");
}

void main(string[] args){
  if(args.length > 3){
    HttpReader c = new HttpReader(args[1],to!ushort(args[2]));
    writeln(c.getRawURL(args[3])[0..100]); // Only first 100 characters to not flush the test
  }else{
    print_usage();
  }
}
