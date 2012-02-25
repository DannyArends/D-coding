/**********************************************************************
 * \file src/game/users/gameclient.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jul, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module game.users.gameclient;

import core.thread;
import std.array;
import std.conv;
import std.file;
import std.path;
import std.socket;
import std.stdio;
import std.string;
import std.uri;

import core.typedefs.webtypes;
import io.events.engine;
import web.socketclient;

class GameClient : Thread{
  private:
  EventHandler handler;
  SocketClient network;
  bool         verbose;
  bool         online;
   
  public:
  this(EventHandler handler, string host = "localhost", ushort port = 3000, bool verbose = false){
    this.network = new SocketClient(host,port);
    this.verbose = verbose;
    this.online  = true;
    this.handler = handler;
    writeln("-----> Setup network");
    super(&run);
  }
  
  ~this(){ network.disconnect(); }
  
  void send(string rawtext){online = network.write(rawtext);writeln("online:",online); }
  void shutdown(){online = false;}
  bool isOnline(){return online;}
  
  void run(){
    try{
      online = network.connect();
      online = network.write("I");
      while(online){
        string s = network.read(1);
        if(s !is null){
          handler.handle(new NetworkEvent(s));
        }
        Thread.sleep( dur!("msecs")( 10 ) );
      }
      writeln("Network Bye...");
    }catch(Throwable exception){
      if(verbose) writeln("Client threw an error");
      return;
    }finally{
      network.disconnect();
    }
  }
  
  void sendHeartbeat(int checks){
    this.send("S:"~to!string(checks));
  }
}
