/**********************************************************************
 * \file src/game/server/clientcommand.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.server.clientcommand;

import core.stdinc;
import core.typedefs.types;
import core.typedefs.location;

import game.tilemap;
import game.server.gameserver;
import game.server.clienthandler;

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

void processCreate(GameServer server, ClientHandler handler, string[] params){
  if(!handler.loggedin){
  if(params.length != 3){
    handler.send(NetEvent.CHAT ~ "Usage: create <name> <pass>");
  }else{
    if(handler.loggedin){
      handler.send(NetEvent.CHAT ~ "Already logged in as '"~handler.username~"'");
    }else{
      if(server.createUser(params[1],params[2])){
        handler.send(NetEvent.CHAT ~ "Created, you are known as '" ~ params[1] ~ "'");
        handleLogin(server, handler, params[1]);
      }else{
        handler.send(NetEvent.CHAT ~ "Unable to create user");
      }
    }
  }
  }else{
    handler.send(NetEvent.CHAT ~ "Already logged in");  
  }
}

void processLogin(GameServer server, ClientHandler handler, string[] params){
  if(!handler.loggedin){
  if(params.length != 3){
    handler.send(NetEvent.CHAT ~ "Usage: login <name> <pass>");
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

void handleLogin(GameServer server, ClientHandler handler, string name){
  handler.username(name);
  server.setUserLogin(name);
  writeln("[CLN] Sending map & Location"); sendLocation(server, handler, true);
  writeln("[CLN] Sending user data"); sendUserData(server, handler);
}

void processClientCommand(GameServer server, ClientHandler handler, string command){
  if(command.length > 0){
    auto plist = split(command," ");
    writeln("[CLN] Command: ",plist[0]);
    if(plist.length > 1) writeln("[CLN] Command args:",plist[1..$]);
    switch(toLower(plist[0])){
      case "create": processCreate(server,handler,plist); break;
      case "login" : processLogin(server,handler,plist); break;
      case "logout": if(handler.loggedin) handler.logout(); break;
      case "stats" : if(handler.loggedin) handler.send(NetEvent.CHAT ~ "Not implemented yet"); break;
      case "chname": if(handler.loggedin) handler.send(NetEvent.CHAT ~ "Not implemented yet"); break;
      case "chpass": if(handler.loggedin) handler.send(NetEvent.CHAT ~ "Not implemented yet"); break;
      case "delete_me": if(handler.loggedin) handler.send(NetEvent.CHAT ~ "Not implemented yet"); break;
      case "save"  : if(handler.loggedin) handler.save(); break;
      case "help"  : displayHelp(handler); break;
      default:
        handler.send(NetEvent.CHAT ~ "Unkown command '" ~ command ~ "'");
      break;
    }
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

void processMovement(GameServer server, ClientHandler handler, string command){
  if(handler.loggedin){
    Location l = new Location(command);
    writeln("Movement from client: ",l);
    handler.setReqLocation(l);
  }
}

void processChat(GameServer server, ClientHandler handler, string command){
  handler.send(NetEvent.GAME ~ server.serverstamp ~ ":" ~ handler.username ~": " ~ command);
}
