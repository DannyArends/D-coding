/******************************************************************//**
 * \file src/game/tests/lqt.d
 * \brief Line, Quad, Triangle test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.lqt;

import std.stdio, std.conv;
import core.typedefs.types;
import core.events.engine;
import game.engine;
import game.games.empty;
import gui.stdinc;
import sfx.engine;

class Test_LQT : Empty{
  public:
  override void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){
    writefln("[ G ] setup3D");
    Texture map = screen.getTexture("map");
    objects ~= new Line(-1, -1,-5, 0, -1,2);
    objects ~= new Line(-10, 2,-30, 0, 5, 5);
    objects ~= new Quad(0, 0,-30);
    for(size_t x=0; x < 30; x++){
      objects ~= new Triangle(-30+x, 5,-30);
    }
    objects[0].setSize(1,1,1);
    objects[1].setSize(1,1,1);
    objects[2].setSize(4,4,1);
    for(size_t x=0; x < 30; x++){
      objects[3+x].setSize(2,2,2);
      objects[3+x].setColor(1,x/30.0,0);
    }
    screen.add(objects);
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  override void update(){
    for(size_t x=0; x < 30; x++){ objects[3+x].rotate(1,x,x/10.0); }
  }
  
  private:
    Object3D[] objects;
    Text   text;
}
