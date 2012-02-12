import std.stdio;

import config.engine;
import gfx.engine;
import sfx.engine;
import game.engine;
import events.engine;

void main(string[] args){
  ConfigEngine config = new ConfigEngine(args);
  GameEngine game = new GameEngine();
  SFXEngine sound = new SFXEngine();
  sound.load();
  GFXEngine graphics = new GFXEngine(game, sound);
  graphics.start();
}
