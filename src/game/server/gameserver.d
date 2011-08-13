module game.server.gameserver;

import std.array;
import std.conv;
import std.file;
import std.path;
import std.socket;
import std.stdio;
import std.string;
import std.uri;

import core.typedefs.webtypes;
import core.web.server;
import game.server.clientcommand;
import game.server.usermanagment;
import game.server.clienthandler;

class GameServer : Server!ClientHandler{
  UserManagment        usermngr;
  //MapManagment       mapsmngr;
  //EventManagment     eventmngr;
    
  this(){
    super();
    usermngr = new UserManagment();
  }
}
