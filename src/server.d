/**
 * \file httpserver.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;
import std.conv;

import core.web.server;
import game.server.clienthandler;

void main(string[] args){
  auto gameserver = new Server!ClientHandler();
  gameserver.start();
}