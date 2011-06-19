/**
 * \file socketclient.d
 * 
 * Description: 
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
 * Contains: 
 * - class: SocketClient
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module core.web.socketclient;

import std.stdio;
import std.socket;

class SocketClient{
  private:
  string host;
  ushort port;
  Socket handle;

  public:
  this(string h, ushort p){
    handle = null;
    host = h;
    port = p;
  }
  
  ~this(){
    host = null;
    port = 0;
    if(handle !is null){
      if(handle.isAlive) handle.close;
      delete handle;
    }
  }
 
  public bool connect(){
    assert(host !is null);
    assert(port > 0);

    handle = new TcpSocket;
    assert(handle.isAlive);
    try{
      handle.connect( new InternetAddress( host, cast(int)port ) );
      handle.blocking(true);
    }catch(SocketException ex){
      writefln("Failed to connect to %s:%d - %s", host, port, ex.toString());
      delete handle;
      return false;
    }
    return true;
  }

  public bool disconnect(){
    if(handle !is null){
      if(handle.isAlive) handle.close;
      delete handle;
    }
    return true;
  }

  public bool isAlive(){
    if(handle !is null){
      return handle.isAlive;
    }
    return false;
  }

  public bool write(string msg){
    if(!isAlive) return false;
    debug writefln("Sending: %s", msg );
    auto ret = handle.send( msg );
    if(!ret) return false;
    return true;
  }

  public string read(uint bufferSize){
    if(!isAlive) return null;
    
    char[] buf = new char[bufferSize];
    auto ret = handle.receive(buf);
    
    if(!ret) return null;
    if(ret == -1) return null;

    char[] data = buf[0 .. ret].dup;

    while(ret == bufferSize){
      delete buf;
      buf = new char[bufferSize];
      ret = handle.receive( buf );
      if( !ret ) return cast(string)data;
      data ~= buf[0 .. ret];
    }
    return cast(string)data;
  }

  public Socket* getHandle(){
    return &handle;
  }
}
