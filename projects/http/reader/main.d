/**********************************************************************
 * \file src/main/httpreader.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jul, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio, std.math, std.conv;
import http.reader.reader;

void print_usage(){
  writeln("   Usage: httpreader host port page");
  writeln("   e.g.: httpreader www.dannyarends.nl 80 /");
}

void main(string[] args){
  ushort port = 80;
  string loc = "/";
  if(args.length > 2) port = to!ushort(args[2]);
  if(args.length > 3) loc = args[3];
  if(args.length > 1){
    HttpReader c = new HttpReader(args[1], port);
    writefln("RawUrl: %s", c.getRawURL(loc)); // Only first 100 characters to not flush the test
  }else{ print_usage(); }
}

