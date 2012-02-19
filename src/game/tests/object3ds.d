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
    text = new Text(10,10,"",screen);
    screen.add(text);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup 3D movement");
    setCameraMotion(new FPMotion(screen));
    writefln("[ G ] setup 3D scene");
    objects ~= new Model3DS(-3, -1,-8,"data/objects/object_3.3ds");
    objects ~= new Skeleton(-1, -1,-5);
    //objects[0].buffer();
    screen.add(objects);
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ to!string(engine.getFPS()));
  }
  
  private:
  Object3D[] objects;
  Text       text;
}
