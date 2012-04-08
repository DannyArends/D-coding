module game.tests.emission;

import std.stdio;
import std.string;
import std.conv;
import std.file;

import core.typedefs.types;
import core.arrays.algebra;
import core.events.engine;
import core.events.mouseevent;

import game.engine;
import gui.stdinc;
import gui.widgets.text;
import sfx.engine;


class Test_PE : Game{
  public:
  override void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){
    writefln("[ G ] setup3D motion");
    cameraMotion(new FPMotion(screen));
    writefln("[ G ] setup3D");
    object = new PE(-50, -10,-100);
    object.addForce(new Gravity());
    screen.add(object);
  }
  
  override void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  override void quit(){
    writefln("[ G ] quit");
  }
  
  override void load(){
    writefln("[ G ] load");
  }
  
  override void save(){
    writefln("[ G ] save");
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  override void handle(Event e){
    writefln("[ G ] event received");
  }
  
  override void update(){
    object.update();
  }
  
  private:
    PE object;
    Text   text;
}
