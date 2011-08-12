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
  
  void processCommand(ubyte[] command){
    if(to!char(command[0]) == 'S') sock.send("Sync request");
    if(to!char(command[0]) == 'I') sock.send("Identification");
    if(to!char(command[0]) == 'M') sock.send("Movement");
    if(to!char(command[0]) == 'H') sock.send("Harvest");
    if(to!char(command[0]) == 'A') sock.send("Attack");
    if(to!char(command[0]) == 'U') sock.send("Use");
    if(to!char(command[0]) == 'C') sock.send("Combine");
    if(to!char(command[0]) == 'L') sock.send("Look at");
    if(to!char(command[0]) == 'T') sock.send("Transfer");
  }
  
  @property
  public Socket socket() {
    return sock;
  }
  
  void offline(){
    online = false;
  }

private:

  void payload() {
    writeln("Client",id,": Starting");
    while(online){
      //writeln("Client",id,": Still here");
      Thread.sleep( dur!("seconds")( 2 ) );
    }
  }
  
  ClientCommand[] toClient;
  Socket sock;
  uint id;
  bool online;
}
