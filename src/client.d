/**
 * \file httpserver.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;
import std.conv;

import game.users.gameclient;

void main(string[] args){
  auto gameclient = new GameClient(3000);
  gameclient.start();
}