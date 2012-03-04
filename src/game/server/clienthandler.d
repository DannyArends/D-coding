/**********************************************************************
 * \file src/game/server/clienthandler.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module game.server.clienthandler;

import core.stdinc;
import core.typedefs.types;
import core.typedefs.webtypes;

import game.server.clientcommand;
import game.server.gameserver;
import web.server;

alias core.thread.Thread Thread;

class ClientHandler : Thread {
  public:
  this(Server!ClientHandler server, Socket sock, uint id) {
    super(&payload);
    this.server = cast(GameServer)server;
    this.sock = sock;
    this.id = id;
    this.online = true;
  }
  
  void processCommand(ubyte[] cmd){
    if(cmd.length > 0){
      string command = arrayToString(cmd[0..($-1)],"",true);
      try{
      switch(command[0]){
        case NetEvent.HEARTBEAT:
          processSync(server, sock, command[1..$]);
        break;
        case 'I':
          processIdentification(server, sock, command[1..$]);
        break;
        case NetEvent.MOVEMENT:
          log(server,"Client " ~ address() ~ " movement: " ~ command);
          processMovement(server, sock, command[1..$]);
        break;
        case NetEvent.CHAT:
          log(server,"Client " ~ address() ~ " chat: " ~ command);
          processChat(server, sock, command[1..$]);
        break;
        default:
          log(server,"Client " ~ address() ~ " unknown command: " ~ to!string(command));
          writeln("Unknown command type:" ~ command[0]);
        break;
      }
      }catch(Throwable exception){
        writeln("Command couldn't be handled" ~ to!string(exception));
      }
    }
  }

  @property Socket socket(){ return sock; }
  @property string address(){
    Address remote = sock.remoteAddress();
    return remote.toAddrString();
  }
  void offline(){ online = false; }
  
  void log(GameServer server, string msg){
    string logfilename = "log"~server.serverday~".SAVE";
    auto f = new File(logfilename,"a");
    f.writeln("[" ~ server.servertime ~ "] " ~ msg);
    f.close();
  }
  
  void close() { 
    log(server,"Client " ~ address() ~ " on " ~ to!string(id) ~ " offline");
    sock.close(); 
  }
  
private:

  void payload() {
    writeln("[CLIENT] Client",id,": starting");
    log(server,"Client " ~ address() ~ " on " ~ to!string(id) ~ " online");
    sock.send(NetEvent.HEARTBEAT ~ server.servertime ~ "\0");
    Thread.sleep( dur!("msecs")( 20 ) );
    sock.send(NetEvent.GAME ~ "Welcome to the server\0");
    Thread.sleep( dur!("msecs")( 20 ) );
    sock.send(NetEvent.GAME ~ "Please login or create a new character\0");
    lastBeat = Clock.currTime();
    while(online){
      if((Clock.currTime() - lastBeat).total!"msecs" >= 5000) {
        sock.send(NetEvent.HEARTBEAT ~ server.servertime ~ "\0");
        lastBeat = Clock.currTime();
      }else{
        Thread.sleep( dur!("msecs")( 20 ) );
      }
    }
    
  }
  
  SysTime    lastBeat;
  GameServer server;
  Socket     sock;
  uint       id;
  bool       online;
}
