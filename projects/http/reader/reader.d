/******************************************************************//**
 * \file src/web/httpreader.d
 * \brief A HTTP reader
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module http.reader.reader;
 
import std.stdio, std.math, std.conv;
import http.socketclient;

class HttpReader : SocketClient{
  string protocol = "HTTP/1.0";

  this(string h, ushort p = 80){ super(h, p); }
  
  string getRawURL(string url = "/", bool verbose = true){
    if(connect()){
      writefln("Connected to %s:%s",host,port);      
      string r;
      if(writeTo("GET " ~ url ~ " " ~ protocol ~ "\r\nHost: " ~ host ~ "\r\n\r\n")){
        writefln("Wrote request");
        r = readFrom(100);
        disconnect();
      }else{
        r = "Write failed";
      }
      return r;
    }else{
      writefln("Not connect to server: '%s'", host);
      return null;
    }
  }
}

