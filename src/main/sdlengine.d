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
import core.terminal;
import gui.engine, sfx.engine, game.engine;

void main(string[] args){
  MSG("Starting game engine");
  GameEngine game = new GameEngine();
  MSG("Starting SFX engine");
  SFXEngine sound = new SFXEngine();
  sound.load();
  MSG("Starting GFX engine");
  GFXEngine graphics = new GFXEngine(game, sound);
  graphics.start();
  MSG("Finished");
}
