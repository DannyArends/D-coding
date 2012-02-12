/**********************************************************************
 * \file src/main/httpserver.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.math;
import std.conv;

import web.server;
import web.httpclient;

void main(string[] args){
  auto http = new Server!HttpClient();
  http.start();
}
