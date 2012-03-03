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
  
  void processCommand(ubyte[] command){
    if(command.length > 0){
      try{
      switch(to!char(command[0])){
        case 'S':
          processSync(server, sock, command[1..$]);
        break;
        case 'I':
          processIdentification(server, sock, command[1..$]);
        break;
        case 'M':
          processMovement(server, sock, command[1..$]);
        break;
        case 'C':
          processChat(server, sock, command[1..$]);
        break;
        default:
          writeln("Unknown command type:" ~ to!char(command[0]));
        break;
      }
      }catch(Throwable exception){
        writeln("Command couldn't be handled" ~ to!string(exception));
      }
    }
  }

  @property public Socket socket() { return sock; }
  
  void offline(){ online = false; }
  void close() { sock.close(); }
  
private:

  void payload() {
    writeln("[CLIENT] Client",id,": starting");
    sock.send(NetEvent.GAME ~ "Welcome to the server\nPlease login or create a new character" ~ to!string('\0'));
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
