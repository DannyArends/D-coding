/******************************************************************//**
 * \file src/web/httpreader.d
 * \brief A HTTP reader
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.httpreader;
 
import std.stdio, std.math, std.conv;
import web.socketclient, core.terminal;

class HttpReader{
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
      string r;
      if(server.write("GET " ~ url ~ " " ~ protocol ~ "\r\nHost: " ~ host ~ "\r\n\r\n")){
        r = server.read(1);
        server.disconnect();
      }else{
        r = "Write failed";
      }
      return r;
    }else{
      ERR("Not connect to server");
      return null;
    }
  }
}
