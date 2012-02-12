module gui.physics;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;

import io.events.engine;
import io.events.keyevent;
import gui.screen;

class Physics : EventHandler{
  this(){ scr=null; }
  this(Screen screen){ scr = screen; }
  
  @property Screen screen(){ return scr; }
  private:
  Screen scr;
}

class SurfacePhysics : Physics{
  void update(){
  
  }
  
  void handle(Event e){
  
  }
}

class ClassicalPhysics : Physics{
  void update(){
  
  }
  
  void handle(Event e){
  
  }
}

class RelativePhysics : Physics{
  void update(){
  
  }
  
  void handle(Event e){
  
  }
}
