/**********************************************************************
 * \file src/game/games/empty.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.games.empty;

import std.stdio;

import core.arrays.algebra;

import core.events.engine;
import game.engine;
import gui.stdinc;
import sfx.engine;

class Empty : Game{
  public:
  override void setup2D(Screen screen){
    writefln("[ G ] setup2D");
  }

  override void setup3D(Screen screen){
    writefln("[ G ] setup3D");
  }
  
  override void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  override void quit(){
    writefln("[ G ] quit");
  }
  
  override void load(){
    writefln("[ G ] load");
  }
  
  override void save(){
    writefln("[ G ] save");
  }
  
  override void render(GFXEngine engine){

  }
  
  override void handle(Event e){
    writefln("[ G ] event received");
  }
  
  private:
}
