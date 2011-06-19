/**
 * \file httpserver.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;
import std.conv;

import core.web.server;

void main(string[] args){
  Server http = new Server();
  http.start("data/websites/DCGI");
}
