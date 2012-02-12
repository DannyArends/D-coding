module game.tests.objects2d;

import std.stdio;
import std.string;
import std.conv;
import std.file;
import std.random;

import sdl.sdlfunctions;

import core.arrays.algebra;
import core.typedefs.types;
import io.events.engine;
import io.events.mouseevent;
import game.engine;
import gui.screen;
import gui.engine;
import gui.objects.liquid;
import gui.widgets.text;
import gui.widgets.square;
import sfx.engine;


class Test_Objects2D : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(10,10,"",screen);
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
  
  void load(GameEngine engine){
    writefln("[ G ] load");
  }
  
  void save(){
    writefln("[ G ] save");
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ to!string(engine.getFPS()));
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
