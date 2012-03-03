module gui.widgets.gamebutton;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import io.events.engine;
import io.events.keyevent;

import game.engine;

import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class GameButton : Button{
  this(int x, int y,string name, GameEngine gameengine, Game game, Object2D parent){
    super(x,y,12*name.length,15,name,parent);
    this.gameengine = gameengine;
    this.game = game;
  }
  
  void onClick(int x, int y){ 
    gameengine.setGameStage(game);
  }
  
  void onDrag(int x, int y){ }
  Event handleKeyPress(KeyEvent key){ return new Event(); }

private:
  GameEngine gameengine;
  Game       game;  
}
