module gui.physics;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;

import core.events.engine;
import core.events.keyevent;
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
