/******************************************************************//**
 * \file src/web/socketclient.d
 * \brief Implementation of a basic socket client
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module http.socketclient;

import std.stdio, std.socket;

class SocketClient{
  this(string h, ushort p = 80){
    host = h;
    port = p;
  }
 
  public bool connect(bool block = true){
    if(host is null){  writefln("Host cannot be null"); return false; }
    if(port <= 0){ writefln("Port needs to be larger then 0"); return false; }
    blocking = block;
    handle   = new TcpSocket;
    if(!handle.isAlive){ writefln("Handle is closed before connection"); return false; }
    try{
      handle.connect( new InternetAddress( host, cast(int)port ) );
      handle.blocking(blocking);
    }catch(SocketException ex){
      writefln("Failed to connect to server (%s:%d)", host, port);
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
    if(handle !is null) return handle.isAlive;
    return false;
  }

  public bool writeTo(string msg){
    if(!isAlive) return false;
    debug writefln("Sending: %s", msg);
    auto ret = handle.send(msg);
    if(!ret) return false;
    if(ret == -1) return false;
    return true;
  }

  public string readFrom(uint bufferSize){
    if(!isAlive) return null;
    
    char[] buf = new char[bufferSize];
    auto ret   = handle.receive(buf);
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

  public Socket* getHandle(){ return &handle; }

  protected:
    string host;
    ushort port     = 80;
    Socket handle   = null;
    bool   blocking = true;
}

