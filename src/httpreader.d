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


void main(string[] args){
  HttpReader c = new HttpReader(args[1],to!ushort(args[2]));
  writeln(c.getRawURL(args[3]));
}
