/******************************************************************//**
 * \file src/game/server/clientcommand.d
 * \brief Client command functions by the gameserver
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.server.clientcommand;

import core.stdinc, core.typedefs.types, core.typedefs.location;
import core.terminal, game.tilemap, game.server.gameserver;
import game.server.clienthandler;

mixin(GenOutput!("CLN", "Green"));

void processSync(GameServer server, ClientHandler handler, string command){

}

void displayHelp(ClientHandler handler){
  handler.send(NetEvent.CHAT ~ "Server v0.1");
  handler.send(NetEvent.CHAT ~ "#help                       Shows this help");
  if(handler.loggedin){
    handler.send(NetEvent.CHAT ~ "#save                       Ask the server to save your user");
    handler.send(NetEvent.CHAT ~ "#stats                      Print some server statistics");
    handler.send(NetEvent.CHAT ~ "#chpass <old> <new> <new>   Changes your password");
    handler.send(NetEvent.CHAT ~ "#chname <new> <pass>        Changes your username");
    handler.send(NetEvent.CHAT ~ "#logout                     Logout from the game");
  }else{
    handler.send(NetEvent.CHAT ~ "#create <name> <pass>       Create a new user");
    handler.send(NetEvent.CHAT ~ "#login <name> <pass>        Login as existing user");
  }
}

void processChpass(GameServer server, ClientHandler handler, string[] params){
  if(handler.loggedin){
  if(params.length != 4){
    handler.send(NetEvent.CHAT ~ "Usage: #chpass <old> <new> <new>");
  }else{
    if(server.validatePass(handler.username, params[1])){
        if(params[2] == params[3]){
          server.updateUser!string(handler.username, params[2], "pass");
          handler.send(NetEvent.CHAT ~ "Password changed");
        }else{
          handler.send(NetEvent.CHAT ~ "Error: Confusion about your new password (no match)");
        }
    }else{
      handler.send(NetEvent.CHAT ~ "Error: Invalid old password provided");
    }
  }
  }else{
    handler.send(NetEvent.CHAT ~ "You must be logged in to change your password");  
  }
}

void processChname(GameServer server, ClientHandler handler, string[] params){
  if(handler.loggedin){
  if(params.length != 3){
    handler.send(NetEvent.CHAT ~ "Usage: #chname <new> <pass>");
  }else{
    if(server.validatePass(handler.username, params[2])){
      if(!server.userExists(params[1])){
        server.updateUser!string(handler.username, params[1], "name");
        handler.send(NetEvent.CHAT ~ "You are from now on known as: '" ~ params[1] ~ "'");
        handleLogin(server, handler, params[1]);
      }else{
        handler.send(NetEvent.CHAT ~ "Error: Name '" ~ params[1] ~ "' not available");
      }
    }else{
      handler.send(NetEvent.CHAT ~ "Error: Invalid password provided");
    }
  }
  }else{
    handler.send(NetEvent.CHAT ~ "You must be logged in to change your name");  
  }
}


void processCreate(GameServer server, ClientHandler handler, string[] params){
  if(!handler.loggedin){
  if(params.length != 3){
    handler.send(NetEvent.CHAT ~ "Usage: #create <name> <pass>");
  }else{
    if(server.createUser(params[1],params[2])){
      handler.send(NetEvent.CHAT ~ "Created, you are known as '" ~ params[1] ~ "'");
      handleLogin(server, handler, params[1]);
    }else{
      handler.send(NetEvent.CHAT ~ "Unable to create user");
    }
  }
  }else{
    handler.send(NetEvent.CHAT ~ "Already logged in");  
  }
}

void processLogin(GameServer server, ClientHandler handler, string[] params){
  if(!handler.loggedin){
  if(params.length != 3){
    handler.send(NetEvent.CHAT ~ "Usage: #login <name> <pass>");
  }else{
    if(!server.userExists(params[1])){
      handler.send(NetEvent.CHAT ~ "No such user '"~params[1]~"'");
    }else{
      if(server.validatePass(params[1],params[2])){
        handler.send(NetEvent.CHAT ~ "Welcome back '" ~ params[1] ~ "'");
        handleLogin(server, handler, params[1]);
      }else{
        handler.send(NetEvent.CHAT ~ "Invalid password");
      }
    }
  }
  }else{
    handler.send(NetEvent.CHAT ~ "Already logged in");
  }
}


void handleDelete(GameServer server, ClientHandler handler){
  if(handler.loggedin){
  if(handler.firsttimedelete){
    handler.send(NetEvent.CHAT ~ "Are you sure? if so #delete_me");
    handler.firsttimedelete = false;
  }else{
    server.deleteUser(handler.username);
    handler.logout();
  }
  }else{
    handler.send(NetEvent.CHAT ~ "This command makes no sense if you're not logged in");
  }
}

void handleLogin(GameServer server, ClientHandler handler, string name){
  handler.username(name);
  server.updateUser!string(name, "", "lastloggedin");
  wCLN("Sending map & Location"); sendLocation(server, handler, true);
  wCLN("Sending user data"); sendUserData(server, handler);
}

void processClientCommand(GameServer server, ClientHandler handler, string command){
  if(command.length > 0){
    auto plist = split(command," ");
    wCLN("Command: %s",plist[0]);
    if(plist.length > 1) wCLN("Command arguments: %s",plist[1..$]);
    switch(toLower(plist[0])){
      case "create": processCreate(server,handler,plist); break;
      case "login" : processLogin(server,handler,plist); break;
      case "logout": if(handler.loggedin) handler.logout(); break;
      case "stats" : if(handler.loggedin) handler.send(NetEvent.CHAT ~ "Not implemented yet"); break;
      case "chname": processChname(server,handler,plist); break;
      case "chpass": processChpass(server,handler,plist); break;
      case "delete_me": handleDelete(server,handler); break;
      case "save"  : if(handler.loggedin) handler.save(); break;
      case "help"  : displayHelp(handler); break;
      default:
        handler.send(NetEvent.CHAT ~ "Unkown command '" ~ command ~ "'");
      break;
    }
    if(toLower(plist[0]) != "delete_me") handler.firsttimedelete = true;
  }
}

void sendMapData(GameServer server, ClientHandler handler){
  if(handler.loggedin){
    TileMap map = handler.getGameUser().map;
    handler.send(NetEvent.OBJECT ~ "Map:" ~ map.asString());
  }else{
    handler.send(NetEvent.CHAT ~ "Unauthorized request");  
  }
}

void sendLocation(GameServer server, ClientHandler handler, bool mapChange = false){
  if(handler.loggedin){
    if(mapChange) sendMapData(server,handler);
    handler.send(NetEvent.MOVEMENT ~ handler.getGameUser().map.name ~ "-" ~ to!string(handler.getGameUser().location));
  }else{
    handler.send(NetEvent.CHAT ~ "Unauthorized request");  
  }
}

void sendUserData(GameServer server, ClientHandler handler){
  if(handler.loggedin){
      handler.send(NetEvent.OBJECT ~ "User:" ~ handler.getPlayer("").asString());
  }else{
    handler.send(NetEvent.CHAT ~ "Unauthorized request");  
  }
}

void log(GameServer server, string msg, string log="server"){
  string logfilename = log ~ server.serverday ~ ".SAVE";
  auto f = new File(logfilename,"a");
  f.writeln("[" ~ server.servertime ~ "] " ~ msg);
  f.close();
}

void processMovement(GameServer server, ClientHandler handler, string command){
  if(handler.loggedin){
    handler.firsttimedelete = true;
    Location l = new Location(command);
    wCLN("Movement request from client: %s", l);
    handler.setReqLocation(l);
  }
}

void processChat(GameServer server, ClientHandler handler, string command){
  if(handler.loggedin) handler.firsttimedelete = true;
  handler.send(NetEvent.GAME ~ server.serverstamp ~ ":" ~ handler.username ~": " ~ command);
}
