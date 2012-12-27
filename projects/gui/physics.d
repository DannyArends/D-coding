/******************************************************************//**
 * \file src/gui/physics.d
 * \brief Physics format definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.physics;

import std.array, std.stdio, std.conv;
import sdl.sdlstructs;
import core.events.engine, core.events.keyevent;
import gui.screen;

class Physics : EventHandler{
  this(){ scr=null; }
  this(Screen screen){ scr = screen; }
  
  @property Screen screen(){ return scr; }
  private:
  Screen scr;
}

class SurfacePhysics : Physics{
  override void update(){
  
  }
  
  override void handle(Event e){
  
  }
}

class ClassicalPhysics : Physics{
  override void update(){
  
  }
  
  override void handle(Event e){
  
  }
}

class RelativePhysics : Physics{
  override void update(){
  
  }
  
  override void handle(Event e){
  
  }
}
