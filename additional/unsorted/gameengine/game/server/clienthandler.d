/******************************************************************//**
 * \file src/game/server/clienthandler.d
 * \brief Client handler functions by the gameserver
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.server.clienthandler;

import core.stdinc;
import core.typedefs.types, core.typedefs.location, core.typedefs.webtypes;
import game.player, game.structures;
import game.server.clientcommand, game.server.gameserver;
import web.server;

alias core.thread.Thread Thread;

class ClientHandler : Thread {
  public:
  this(Server!ClientHandler server, Socket sock, uint id) {
    this.server = cast(GameServer)server;
    this.sock = sock;
    this.id = id;
    _online = true;
    super(&payload);
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
              send(NetEvent.CHAT ~ "Please login first '#login <name> <password>'");
            }
          }
        break;
        default:
          log(server,"Client " ~ address() ~ " unknown command: " ~ to!string(command));
          send(NetEvent.CHAT ~ "Unknown command: " ~ cmd[0]);
          writeln("[HANDLER] Unknown command type:" ~ cmd[0]);
        break;
      }
      }catch(Throwable exception){
        writeln("Command couldn't be handled" ~ to!string(exception));
      }
    }
  }
  
  void setReqLocation(Location loc){
    server.updateUser!Location(_username, loc, "requested");
  }
  
  @property{
    Socket socket(){ return sock; }
    void send(string cmd){ 
      if(cmd[($-1)] != '\0') cmd ~= "\0";
      sock.send(cmd); 
    }
    
    string address(){
      Address remote = sock.remoteAddress();
      return remote.toAddrString();
    }
    
    string username(string user = ""){ 
      if(user != ""){ _username=user; }
      if(_username == "") return "GUEST"~to!string(id);
      return _username; 
    }
      
    bool loggedin(){ if(_username == ""){ return false; } return true; }

    bool online(){ return _online; }
  }
  
  void offline(){ 
    if(loggedin()) server.logoutUser(_username);
    _online = false; 
  }
  
  void close() { 
    log(server,"Client " ~ address() ~ " on " ~ to!string(id) ~ " offline");
    sock.close(); 
  }

  void logout(){
    server.logoutUser(_username);
    send(NetEvent.CHAT ~ "You are now logged out");
    send(NetEvent.GAME ~ "logout");
    _username = ""; 
  }

  bool save(){ 
    send(NetEvent.CHAT ~ "Asking to save");
    return server.saveUser(_username); 
  }

  Player getPlayer(string name){ 
    if(name == ""){ name = _username; } return server.getPlayer(name); 
  }

  GameUser getGameUser(){ return getPlayer("").info; }
  
  bool       firsttimedelete = true;
  
private:

  void payload(){
    wCLN("Starting a new client (%s)", id);
    log(server,"Client " ~ address() ~ " on " ~ to!string(id) ~ " online");
    send(NetEvent.HEARTBEAT ~ server.servertime);
    Thread.sleep( dur!("msecs")( 20 ) );
    send(NetEvent.CHAT ~ "Welcome to the server");
    Thread.sleep( dur!("msecs")( 20 ) );
    send(NetEvent.CHAT ~ "Please login or create a new character");
    lastBeat = Clock.currTime();
    while(_online){
      if((Clock.currTime() - lastBeat).total!"msecs" >= 5000) {
        send(NetEvent.HEARTBEAT ~ server.servertime);
        lastBeat = Clock.currTime();
      }else{
        Thread.sleep( dur!("msecs")( 20 ) );
      }
    }
    wCLN("Client (%s) stopped", id);
  }
  
  SysTime    lastBeat;
  GameServer server;
  Socket     sock;
  string     _username = "";
  uint       id;
  bool       _online;
}
