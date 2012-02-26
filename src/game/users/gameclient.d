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
  this(EventHandler handler, string host = "localhost", ushort port = 3000, bool verbose = true){
    this.network = new SocketClient(host, port);
    this.verbose = verbose;
    this.online  = true;
    this.handler = handler;
    super(&run);
    writeln("[NET] Network setup done");
  }
  
  ~this(){ network.disconnect(); }
  
  void send(string rawtext){
    online = network.write(rawtext);
    writeln("[NET] Online:",online); 
  }
  
  void shutdown(){ online = false; }
  bool isOnline(){ return online; }
  
  void run(){
    try{
      online = network.connect();
      while(online){
        string s = network.read(1);
        if(s !is null){
          //writeln("[NET] Network:",s);
          handler.handle(new NetworkEvent(s));
        }
        Thread.sleep( dur!("msecs")( 10 ) );
      }
      writeln("[NET] Network closing down");
      network.disconnect();
    }catch(Throwable exception){
      if(verbose) writeln("[NET] GameClient threw an error");
      return;
    }
  }
  
  void sendHeartbeat(int checks){
    send("S:"~to!string(checks));
  }
}
