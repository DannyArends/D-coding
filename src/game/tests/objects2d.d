/**********************************************************************
 * \file src/game/tests/object2d.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.objects2d;

import std.stdio;
import std.string;
import std.conv;
import std.file;
import std.random;

import sdl.sdlfunctions;

import core.arrays.algebra;
import core.typedefs.types;
import core.events.engine;
import core.events.mouseevent;
import game.engine;
import gui.stdinc;
import sfx.engine;


class Test_Objects2D : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(screen, 10, 10);
    gun = new Square(0,200,300,300,screen);
    gun.setTexture(screen.getTextureID("Gun1"));
    target = new Square(400,50,200,240,screen);
    target.setTexture(screen.getTextureID("Target"));

    screen.add(text);
    screen.add(gun);
    screen.add(target);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(){
    writefln("[ G ] quit");
  }
  
  void load(){
    writefln("[ G ] load");
  }
  
  void save(){
    writefln("[ G ] save");
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  void handle(Event e){
    writefln("[ G ] event received");
  }
  
  void update(){
  }
  
  private:
  Text   text;
  Square gun;
  Square target;
}
