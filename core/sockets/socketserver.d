/**
 * \file socketserver.d
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
 * - class: socketserver
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
module sockets.socketserver;

import std.stdio;
import std.socket;

class socketserver{
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

  
  bool Connect(){
    assert(host !is null);
    assert(port > 0);

    handle = new TcpSocket;
    assert( handle.isAlive );
    
    // Connect
    try{
      handle.connect( new InternetAddress( host, cast(int)port ) );
    }catch( SocketException e ){
      writefln( "Failed to connect to %s:%d - %s", host, port, e.toString() );
      delete handle;
      return false;
    }
    return true;
  }

  bool Disconnect(){
    if(handle !is null){
      if(handle.isAlive) handle.close;
      delete handle;
    }
    return true;
  }

  bool IsAlive(){
    if( handle !is null )
      return handle.isAlive;
    return false;
  }

  bool Write( string msg ){
    if( !IsAlive )
      return false;

    writefln( "SENDING: %s", msg );

    auto ret = handle.send( msg ~ "\n" );
    if( !ret )
      return false;

    return true;
  }

  string Read( uint bufferSize=1024 ){
    if(!IsAlive) return null;
    
    char[] buf = new char[bufferSize];
    auto ret = handle.receive( buf );
    
    if( !ret ) return null;
    if( ret == -1 ) return null;

    char[] data = buf[0 .. ret].dup;
    // If we didn't manage to read everything to the buffer
    // read the rest..
    while( ret == bufferSize ){
      delete buf;
      buf = new char[bufferSize];
      ret = handle.receive( buf );
      if( !ret )
        return cast(string)data;
      data ~= buf[0 .. ret];
    }
    return cast(string)data;
  }

  Socket* GetHandle(){
    return &handle;
  }
}
