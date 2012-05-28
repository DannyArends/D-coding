/******************************************************************//**
 * \file src/game/users/gameclient.d
 * \brief Network communication for a client
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jul, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.users.gameclient;

import core.stdinc, core.terminal, core.typedefs.webtypes;
import core.events.engine, core.events.networkevent;
import web.socketclient;

alias core.thread.Thread Thread;

mixin(GenOutput!("NET", "Green"));

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
    wNET("Network setup done");
  }
  
  ~this(){ network.disconnect(); }
  
  void send(string rawtext){
    if(rawtext[($-1)] != '\0') rawtext ~= "\0";
    online = network.write(rawtext);
    debug wNET("Network online: %s",online); 
  }
  
  void shutdown(){ online = false; }
  bool isOnline(){ return online; }
  
  void run(){
    try{
      online = network.connect();
      while(online){
        string s = chomp(network.read(1));
        if(s !is null && s.length >= 1){
          try{
            foreach(string cmd ; s.split("\0")){
              if(cmd !is null && cmd.length >= 1){
                handler.handle(new NetworkEvent(cmd));
              }
            }
          }catch(Throwable exception){
            ERR("Unable to handle command: %s",s);
          }
        }
        Thread.sleep( dur!("msecs")( 10 ) );
      }
      WARN("Network closing down");
      network.disconnect();
    }catch(Throwable exception){
      ERR("GameClient threw an error");
      return;
    }
  }
  
  void sendHeartbeat(int checks){
    send("S:" ~ to!string(checks));
  }
}
