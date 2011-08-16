module game.server.clientcommand;

import std.stdio;
import std.conv;
import std.socket;
import core.memory;

import game.server.gameserver;

void processSync(GameServer server, Socket sock, ubyte[] command){
  
}

//This should be a Server Object function
bool doLogin(string loginstring){
  if(loginstring[0]== '[' && loginstring[$-1]== ']'){
    return true;
  }else{
    return false;
  }
}

//This should be a Server Object function
bool doCreation(string creationstring){
  return false;
}

void processIdentification(GameServer server, Socket sock, ubyte[] command){
  if(command.length > 0){
    switch(to!char(command[0])){
      case 'L':
        sock.send("C:Starting login process");
        sock.send("S:W:LOGIN");
      break;
      case 'C':
        sock.send("C:Starting new character creation");
        sock.send("S:W:CREATE");
      break;
      case 'A':
        string login = to!string(command[1..$]);
        sock.send("C:Attempting login process");
        if(doLogin(login)){
          sock.send("C:Login OK");
        }else{
          sock.send("C:Unable to login");
        }
      break;
      case 'N':
        string newcharacter = to!string(command[1..$]);
        sock.send("C:Attempting creation process");
        if(doCreation(newcharacter)){
          sock.send("C:Creation OK");
        }else{
          sock.send("C:Unable to create");
        }
      break;
      default:
        sock.send("C:HUH?");
      break;
    }
  }else{
    sock.send("C:Welcome to the server please login, or create a new account");
    sock.send("S:W:CHOOSE");
    server.usermngr.createUser("Danny","Arends");
  }
}

void processMovement(GameServer server, Socket sock, ubyte[] command){
  
}

void processChat(GameServer server, Socket sock, ubyte[] command){
    
}
