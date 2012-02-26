/**********************************************************************
 * \file src/game/server/gameserver.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module game.server.gameserver;

import core.stdinc;
import core.typedefs.webtypes;

import web.server;
import game.server.clientcommand;
import game.server.usermanagment;
import game.server.clienthandler;

class GameServer : Server!ClientHandler{
  private:
    UserManagment  usermngr;
  
  public:
    this(){
      super();
      usermngr = new UserManagment();
    }
}
