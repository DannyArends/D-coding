/******************************************************************//**
 * \file src/main/sdlengine.d
 * \brief Main function for rake app::sdl
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written May, 2011<br>
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
