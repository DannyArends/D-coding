module game.games.empty;

import std.stdio;

import core.arrays.algebra;

import io.events.engine;
import game.engine;
import gui.engine;
import gui.screen;
import gui.objects.quad;
import gui.widgets.text;
import sfx.engine;

class Empty : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
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

  }
  
  void handle(Event e){
    writefln("[ G ] event received");
  }
  
  private:
}
