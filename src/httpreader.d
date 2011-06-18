/**
 * \file httpreader.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;
import std.conv;

import core.web.httpclient;


void main(string[] args){
  HttpClient c = new HttpClient(args[1],to!ushort(args[2]));
  writeln(c.getRawURL(args[3]));
}
