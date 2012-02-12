module game.tests.liquid;

import std.stdio;
import std.conv;
import std.random;

import core.typedefs.types;
import io.events.engine;
import game.engine;
import game.games.empty;
import gui.engine;
import gui.screen;
import gui.motion;
import gui.objects.liquid;
import gui.widgets.text;
import sfx.engine;

class Test_Liquid : Empty{
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
    Texture map = screen.getTexture("map");
    liquid = new Liquid(-50, -10,-100, map);
    liquid.rotate(0,20,0);
    screen.add(liquid);
  }
  
  void load(GameEngine engine){
   // engine.requestUpdate(1.0);
   // liquid.buffer();
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ to!string(engine.getFPS()));
  }
  
  void handle(Event e){
    writefln("[ G ] event received");
    if(e.getEventType() == EventType.MOUSE){
      liquid.effect(uniform(0, liquid.getMapX()),uniform(0, liquid.getMapY()),uniform(0, 100));
    }
  }
  
  void update(){
    liquid.update();
  }
  
  private:
  Liquid liquid;
  Text   text;
}
