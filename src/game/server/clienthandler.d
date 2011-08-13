module game.server.clienthandler;

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
import game.server.gameserver;
import core.web.server;

class ClientHandler : Thread {
  public:
  this(Server!ClientHandler s, Socket sock, uint id) {
    super(&payload);
    server = cast(GameServer)s;
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
  
  GameServer server;
  Socket sock;
  uint id;
  bool online;
}
