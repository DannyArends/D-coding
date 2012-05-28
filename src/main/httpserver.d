/******************************************************************//**
 * \file src/main/httpserver.d
 * \brief Main function for a basic HTTP server
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio, std.math, std.conv;
import web.server, web.httpclient;

void main(string[] args){
  auto http = new Server!HttpClient();
  http.start();
}
