/**
 * \file httpreader.D
 *
 * last modified Jun, 2011
 * first written Jun, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: HttpReader
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
module core.web.httpreader;
 
import std.stdio;
import std.math;
import std.conv;

import core.web.socketclient;

class HttpReader {
  SocketClient server;
  string host;
  string protocol = "HTTP/1.0";
  ushort port = 80;

  this(string h, ushort p = 80){
    host = h;
    port = p;
    server = new SocketClient(h,p);
  }
  
  string getRawURL(string url = "/"){
    if(server.connect()){
      server.write("GET " ~ url ~ " " ~ protocol ~ "\r\nHost: " ~ host ~ "\r\n\r\n");
      string r = server.read(1);
      server.disconnect();
      return r;
    }else{
      return null;
    }
  }
  
}
