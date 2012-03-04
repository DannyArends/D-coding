/******************************************************************//**
 * \file src/main/server.d
 * \brief Main function for rake app::gameserver
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.string;
import std.math;
import std.conv;

//import core.web.server;
import game.server.gameserver;

void main(string[] args){
  auto gameserver = new GameServer();
  gameserver.start();
  
  string cmd = readln();
  while(strip(cmd) != "q"){
    cmd = readln();
  }
  gameserver.shutdown();
}