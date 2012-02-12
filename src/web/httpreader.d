/**********************************************************************
 * \file src/web/httpreader.d
 * Loosly Based on: http://github.com/burjui/quarkHTTPd/
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.httpreader;
 
import std.stdio;
import std.math;
import std.conv;

import web.socketclient;

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
