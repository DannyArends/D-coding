/**
 * \file httpserver.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;
import std.conv;

//import core.web.server;
import game.server.gameserver;

void main(string[] args){
  auto gameserver = new GameServer();
  gameserver.start();
}