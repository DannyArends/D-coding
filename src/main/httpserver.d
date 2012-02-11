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
import core.web.httpclient;

void main(string[] args){
  auto http = new Server!HttpClient();
  http.start();
}
