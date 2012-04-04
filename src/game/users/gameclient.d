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

import core.stdinc;

import core.typedefs.webtypes;
import core.events.engine;
import core.events.networkevent;
import web.socketclient;

alias core.thread.Thread Thread;

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
        string s = chomp(network.read(1));
        if(s !is null && s.length >= 1){
          try{
            foreach(string cmd ; s.split("\0")){
              if(cmd !is null && cmd.length >= 1){
                handler.handle(new NetworkEvent(cmd ~ "\0"));
              }
            }
          }catch(Throwable exception){
            writeln("[NET] Unable to handle command:",s,"\n",exception);
          }
        }
        Thread.sleep( dur!("msecs")( 10 ) );
      }
      writeln("[NET] Network closing down");
      network.disconnect();
    }catch(Throwable exception){
      if(verbose) writeln("[NET] GameClient threw an error\n",exception);
      return;
    }
  }
  
  void sendHeartbeat(int checks){
    send("S:"~to!string(checks));
  }
}
