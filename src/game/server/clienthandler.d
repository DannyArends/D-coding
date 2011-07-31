/**
 * \file gameclient.d
 *
 * last modified Juli, 2011
 * first written Juli, 2011
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: GameClient
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module core.game.server.clienthandler;

import core.thread;
import std.concurrency;
import std.array;
import std.conv;
import std.file;
import std.path;
import std.socket;
import std.stdio;
import std.string;
import std.uri;

import core.typedefs.webtypes;

class ClientHandler : Thread {
  private Socket sock;
  private uint id;
  private bool online;
  
  public this(Socket sock, uint id) {
    super(&payload);
    this.sock = sock;
    this.id = id;
    this.online = true;
  }
	
  public void close() {
    sock.close();
  }
  
  @property
  public Socket socket() {
    return sock;
  }
  
  void offline(){
    online = false;
  }
  
  private void payload() {
    writeln("Client",id," starts up");
    while(online){
      writeln("Client",id," still here up");
      Thread.sleep( dur!("seconds")( 2 ) );
    }
  }
}
