/**********************************************************************
 * \file src/main/server.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.math;
import std.conv;

//import core.web.server;
import game.server.gameserver;

void main(string[] args){
  auto gameserver = new GameServer();
  gameserver.start();
}