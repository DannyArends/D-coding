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

void processSync(GameServer server, Socket sock, string command){
  
}

//This should be a Server Object function
bool doLogin(GameServer server, string loginstring){
  if(loginstring[0]== '[' && loginstring[$-1]== ']'){
    return true;
  }else{
    return false;
  }
}

//This should be a Server Object function
bool doCreation(GameServer server, string creationstring){
  return false;
}

void processIdentification(GameServer server, Socket sock, string command){
  if(command.length > 0){
    switch(to!char(command[0])){
      case 'C':
        sock.send(NetEvent.GAME ~ "Starting new character creation"~ to!string('\0'));
        sock.send("S:W:CREATE"~ to!string('\0'));
      break;
      case 'A':
        string login = to!string(command[1..$]);
        sock.send(NetEvent.GAME ~ "Attempting login process"~ to!string('\0'));
        if(doLogin(server, login)){
          sock.send(NetEvent.GAME ~ "Login OK"~ to!string('\0'));
        }else{
          sock.send(NetEvent.GAME ~ "Unable to login"~ to!string('\0'));
        }
      break;
      case 'N':
        string newcharacter = to!string(command[1..$]);
        sock.send(NetEvent.GAME ~ "Attempting creation process"~ to!string('\0'));
        if(doCreation(server,newcharacter)){
          sock.send(NetEvent.GAME ~ "Creation OK"~ to!string('\0'));
        }else{
          sock.send(NetEvent.GAME ~ "Unable to create"~ to!string('\0'));
        }
      break;
      default:
        sock.send(NetEvent.GAME ~ "wrong ID command\0");
      break;
    }
  }else{
    sock.send(NetEvent.GAME ~ "Welcome please login, or create a new account" ~ to!string('\0'));
    sock.send("S:W:LOGIN"~ to!string('\0'));
  }
}

void processMovement(GameServer server, Socket sock, string command){
  
}

void processChat(GameServer server, Socket sock, string command){
  sock.send(NetEvent.GAME ~ server.serverstamp ~ ": " ~ command ~ "\0");
}
