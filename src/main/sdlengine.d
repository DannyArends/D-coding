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
