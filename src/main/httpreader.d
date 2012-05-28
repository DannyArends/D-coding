/**********************************************************************
 * \file src/main/httpreader.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jul, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio, std.math, std.conv;
import web.httpreader;

void print_usage(){
  writeln("   Usage: httpreader host port page");
  writeln("   e.g.: httpreader www.dannyarends.nl 80 /");
}

void main(string[] args){
  if(args.length > 3){
    HttpReader c = new HttpReader(args[1],to!ushort(args[2]));
    writeln(c.getRawURL(args[3])); // Only first 100 characters to not flush the test
  }else{
    print_usage();
  }
}
