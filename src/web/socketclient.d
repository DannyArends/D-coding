/******************************************************************//**
 * \file src/web/socketclient.d
 * \brief Implementation of a basic socket client
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module web.socketclient;

import std.stdio, std.socket;

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
      handle.blocking(false);
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
    if(ret == -1) return false;
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
      if(ret == -1) return cast(string)data;
      data ~= buf[0 .. ret];
    }
    return cast(string)data;
  }

  public Socket* getHandle(){
    return &handle;
  }
}
