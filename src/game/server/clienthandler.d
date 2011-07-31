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
import game.server.clientcommand;

class ClientHandler : Thread {
  public:
  this(Socket sock, uint id) {
    super(&payload);
    this.sock = sock;
    this.id = id;
    this.online = true;
  }
	
  void close() {
    sock.close();
  }
  
  void addToBuffer(ubyte[] buffer){
    if(inBuffer.length + buffer.length <= 1_048_576 ){
      inBuffer ~= buffer;
    }else{
      writeln("Client",id,": Buffer full");
    }
  }
  
  @property
  public Socket socket() {
    return sock;
  }
  
  void offline(){
    online = false;
  }

private:
  void processCommandFromClient(){
    //TODO processing
  }
  
  void sendCommandToClient(){
    //TODO Get first command from list and send
  }

  void payload() {
    writeln("Client",id,": Starting");
    while(online){
      //writeln("Client",id,": Still here");
      Thread.sleep( dur!("seconds")( 2 ) );
      processCommandFromClient();
      sendCommandToClient();
    }
  }
  
  ClientCommand[] toClient;
  Socket sock;
  uint id;
  bool online;
  byte[] inBuffer;
}
