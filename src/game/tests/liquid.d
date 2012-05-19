/******************************************************************//**
 * \file src/game/tests/liquid.d
 * \brief Liquid map test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.liquid;

import std.stdio, std.conv, std.random;

import core.typedefs.types;
import core.events.engine;
import game.engine;
import game.games.empty;
import gui.stdinc;
import sfx.engine;

class Test_Liquid : Empty{
  public:
  override void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){
    writefln("[ G ] setup 3D movement");
    cameraMotion(new FPMotion(screen));
    writefln("[ G ] setup 3D scene");
    Texture map = screen.getTexture("map");
    liquid = new Liquid(-50, -10,-100, map);
    liquid.rotate(0,20,0);
    screen.add(liquid);
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  override void handle(Event e){
    writefln("[ G ] event received");
    if(e.getEventType() == EventType.MOUSE){
      liquid.effect(uniform(0, liquid.getMapX()),uniform(0, liquid.getMapY()),uniform(0, 100));
    }
  }
  
  override void update(){
    liquid.update();
  }
  
  private:
    Liquid liquid;
    Text   text;
}
