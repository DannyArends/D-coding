/**********************************************************************
 * \file src/game/tests/object3ds.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.object3ds;

import std.stdio;
import std.conv;

import core.typedefs.types;
import io.events.engine;
import game.engine;
import game.games.empty;
import gui.stdinc;
import sfx.engine;

class Test_Object3DS : Empty{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup 3D movement");
    cameraMotion(new FPMotion(screen));
    writefln("[ G ] setup 3D scene");
    objects ~= new Model3DS(-3, -1,-8,"data/objects/object_3.3ds");
    objects ~= new Skeleton(-1, -1,-5);
    //objects[0].buffer();
    screen.add(objects);
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  private:
  Object3D[] objects;
  Text       text;
}
