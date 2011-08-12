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
    if(command.length > 0){
      try{
      switch(to!char(command[0])){
        case 'S':
          processSync(sock, command[1..$]);
        break;
        case 'I':
          processIdentification(sock, command[1..$]);
        break;
        case 'M':
          processMovement(sock, command[1..$]);
        break;
        case 'C':
          processChat(sock, command[1..$]);
        break;
        default:
          writeln("Unknown command type");
        break;
      }
      }catch(Throwable exception){
        writeln("Command couldn't be handled");
      }
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

  void payload() {
    writeln("Client",id,": Starting");
    while(online){
      //writeln("Client",id,": Still here");
      Thread.sleep( dur!("seconds")( 2 ) );
    }
  }
  
  Socket sock;
  uint id;
  bool online;
}
