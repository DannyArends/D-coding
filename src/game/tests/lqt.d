module game.tests.lqt;

import std.stdio;
import std.conv;

import core.typedefs.types;
import io.events.engine;
import game.engine;
import game.games.empty;
import gui.engine;
import gui.screen;
import gui.motion;
import gui.objects.object3d;
import gui.objects.line;
import gui.objects.quad;
import gui.objects.triangle;
import gui.widgets.text;
import sfx.engine;


class Test_LQT : Empty{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(10,10,"",screen);
    screen.add(text);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
    Texture map = screen.getTexture("map");
    objects ~= new Line(-1, -1,-5, 0, -1,2);
    objects ~= new Line(-10, 2,-30, 0, 5, 5);
    objects ~= new Quad(0, 0,-30);
    for(int x=0;x<30;x++){
      objects ~= new Triangle(-30+x, 5,-30);
    }
    objects[0].setSize(1,1,1);
    objects[1].setSize(1,1,1);
    objects[2].setSize(4,4,1);
    for(int x=0;x<30;x++){
      objects[3+x].setSize(2,2,2);
      objects[3+x].setColor(1,x/30.0,0);
    }
    screen.add(objects);
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ to!string(engine.getFPS()));
  }
  
  void update(){
    for(int x=0;x<30;x++){
      objects[3+x].rotate(1,x,x/10.0);
    }
  }
  
  private:
  Object3D[] objects;
  Text   text;
}
