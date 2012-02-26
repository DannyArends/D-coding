module game.tests.emission;

import std.stdio;
import std.string;
import std.conv;
import std.file;

import core.typedefs.types;
import core.arrays.algebra;

import io.events.engine;
import io.events.mouseevent;
import game.engine;
import gui.stdinc;
import gui.widgets.text;
import sfx.engine;


class Test_PE : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(10,10,"",screen);
    screen.add(text);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D motion");
    setCameraMotion(new FPMotion(screen));
    writefln("[ G ] setup3D");
    object = new PE(-50, -10,-100);
    object.addForce(new Gravity());
    screen.add(object);
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(){
    writefln("[ G ] quit");
  }
  
  void load(GameEngine engine){
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
    object.update();
  }
  
  private:
  PE object;
  Text   text;
}
