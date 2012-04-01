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
import game.player;
import game.structures;
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
    if(cmd.length > 1){
      string command = arrayToString(cmd[1..($-1)],"",true);
      try{
      switch(cmd[0]){
        case NetEvent.HEARTBEAT:
          processSync(server, this, command);
        break;
        case '#':
          processClientCommand(server, this, command);
        break;
        case NetEvent.MOVEMENT:
          processMovement(server, this, command);
        break;
        case NetEvent.CHAT:
          log(server, "Client " ~ address() ~ " chat: " ~ command, "chat");
          if(cmd.length > 2 && command[0]=='#'){
            processCommand(cmd[1..$]);
          }else{
            if(loggedin){
              if(command.length >= 1) processChat(server, this, command);
            }else{
              send(NetEvent.GAME ~ "Please login first '#login <name> <password>'\0");
            }
          }
        break;
        default:
          log(server,"Client " ~ address() ~ " unknown command: " ~ to!string(command));
          send(NetEvent.GAME ~ "Unknown command: " ~ cmd[0] ~ "\0");
          writeln("[HANDLER] Unknown command type:" ~ cmd[0]);
        break;
      }
      }catch(Throwable exception){
        writeln("Command couldn't be handled" ~ to!string(exception));
      }
    }
  }

  @property Socket socket(){ return sock; }
  @property void send(string cmd){ sock.send(cmd); }
  @property string address(){
    Address remote = sock.remoteAddress();
    return remote.toAddrString();
  }
  void offline(){ online = false; }
  
  void log(GameServer server, string msg, string log="server"){
    string logfilename = log ~ server.serverday ~ ".SAVE";
    auto f = new File(logfilename,"a");
    f.writeln("[" ~ server.servertime ~ "] " ~ msg);
    f.close();
  }
  
  void close() { 
    log(server,"Client " ~ address() ~ " on " ~ to!string(id) ~ " offline");
    sock.close(); 
  }
  
  @property string username(string user = ""){ 
    if(user != ""){ _username=user; }
    if(_username == "") return "GUEST"~to!string(id);
    return _username; 
  }
  
  @property bool loggedin(){ 
    if(_username == "") return false;
    return true;
  }
  
  void logout(){
    server.saveUser(_username);
    send(NetEvent.GAME ~ "You are now logged out\0");
    _username = ""; 
  }

  bool save(){ 
    send(NetEvent.GAME ~ "Asking to save\0");
    return server.saveUser(_username); 
  }

  GameUser getGameUser(){ return server.getGameUser(_username); }
  
private:

  void payload(){
    writeln("[CLIENT] Client",id,": starting");
    log(server,"Client " ~ address() ~ " on " ~ to!string(id) ~ " online");
    sock.send(NetEvent.HEARTBEAT ~ server.servertime ~ "\0");
    Thread.sleep( dur!("msecs")( 20 ) );
    sock.send(NetEvent.CHAT ~ "Welcome to the server\0");
    Thread.sleep( dur!("msecs")( 20 ) );
    sock.send(NetEvent.CHAT ~ "Please login or create a new character\0");
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
  string     _username = "";
  uint       id;
  bool       online;
}
