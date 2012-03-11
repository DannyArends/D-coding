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

import game.server.gameserver;
import game.server.clienthandler;

void processSync(GameServer server, ClientHandler handler, string command){

}

void displayHelp(ClientHandler handler){
  handler.send(NetEvent.GAME ~ "Server v0.1\0");
  handler.send(NetEvent.GAME ~ "#help                       Shows this help\0");
  if(handler.loggedin){
    handler.send(NetEvent.GAME ~ "#save                       Ask the server to save your user\0");
    handler.send(NetEvent.GAME ~ "#stats                      Print some server statistics\0");
    handler.send(NetEvent.GAME ~ "#chpass <old> <new> <new>   Changes your password\0");
    handler.send(NetEvent.GAME ~ "#chname <new> <pass>        Changes your username\0");
    handler.send(NetEvent.GAME ~ "#logout                     Logout from the game\0");
  }else{
    handler.send(NetEvent.GAME ~ "#create <name> <pass>       Create a new user\0");
    handler.send(NetEvent.GAME ~ "#login <name> <pass>        Login as existing user\0");
  }
}

void processCreate(GameServer server, ClientHandler handler, string[] params){
  if(params.length != 3){
    handler.send(NetEvent.GAME ~ "Usage: create <name> <pass>\0");
  }else{
    if(handler.loggedin){
      handler.send(NetEvent.GAME ~ "Already logged in as '"~handler.username~"'\0");
    }else{
      if(server.createUser(params[1],params[2])){
        handler.username(params[1]);
        handler.send(NetEvent.GAME ~ "Created, you are known as '" ~ params[1] ~ "'\0");
        sendLocation(server, handler);
      }else{
        handler.send(NetEvent.GAME ~ "Unable to create user\0");
      }
    }
  }
}

void processLogin(GameServer server, ClientHandler handler, string[] params){
  if(params.length != 3){
    handler.send(NetEvent.GAME ~ "Usage: login <name> <pass>\0");
  }else{
    if(!server.userExists(params[1])){
      handler.send(NetEvent.GAME ~ "No such user '"~params[1]~"'\0");
    }else{
      if(server.validatePass(params[1],params[2])){
        handler.username(params[1]);
        handler.send(NetEvent.GAME ~ "Welcome back '" ~ params[1] ~ "'\0");
        sendLocation(server, handler);
      }else{
        handler.send(NetEvent.GAME ~ "Invalid password\0");
      }
    }
  }
}

void processClientCommand(GameServer server, ClientHandler handler, string command){
  if(command.length > 0){
    auto plist = split(command," ");
    writeln("[CLN] Command: ",plist[0]);
    if(plist.length > 1) writeln(", args:",plist[1..$]);
    switch(toLower(plist[0])){
      case "create": processCreate(server,handler,plist); break;
      case "login" : processLogin(server,handler,plist); break;
      case "logout": if(handler.loggedin) handler.logout(); break;
      case "stats" : if(handler.loggedin) handler.send(NetEvent.GAME ~ "Not implemented yet"); break;
      case "chname": if(handler.loggedin) handler.send(NetEvent.GAME ~ "Not implemented yet"); break;
      case "chpass": if(handler.loggedin) handler.send(NetEvent.GAME ~ "Not implemented yet"); break;
      case "save"  : if(handler.loggedin) handler.save(); break;
      case "help"  : displayHelp(handler); break;
      default:
        handler.send(NetEvent.GAME ~ "Unkown command '" ~ command ~ "'\0");
      break;
    }
  }
}

void sendLocation(GameServer server, ClientHandler handler){
  if(handler.loggedin){
    handler.send(NetEvent.MOVEMENT ~ handler.getGameUser().map.name ~ "-" ~ to!string(handler.getGameUser().location) ~ "\0");
  }else{
    handler.send(NetEvent.GAME ~ "Unauthorized request\0");  
  }
}

void processMovement(GameServer server, ClientHandler handler, string command){
  
}

void processChat(GameServer server, ClientHandler handler, string command){
  handler.send(NetEvent.GAME ~ server.serverstamp ~ ":" ~ handler.username ~": " ~ command ~ "\0");
}
