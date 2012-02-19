/**********************************************************************
 * \file src/main/sdlengine.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;

import gui.engine;
import sfx.engine;
import game.engine;

void main(string[] args){
  GameEngine game = new GameEngine();
  SFXEngine sound = new SFXEngine();
  sound.load();
  GFXEngine graphics = new GFXEngine(game, sound);
  graphics.start();
}
