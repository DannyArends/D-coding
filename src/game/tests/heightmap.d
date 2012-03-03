module game.tests.heightmap;

import std.stdio;
import std.conv;

import core.typedefs.types;
import io.events.engine;
import io.events.mouseevent;

import game.engine;
import game.games.empty;
import gui.stdinc;
import sfx.engine;

class Test_HeightMap : Empty{
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
    Texture map = screen.getTexture("map");
    heightmap = new HeightMap(-50, -10,-100, map);
    heightmap.rotate(0,20,0);
    screen.add(heightmap);
  }
  
  void load(GameEngine engine){
    heightmap.buffer();
  }
  
  void handle(Event e){
    if(e.getEventType() == EventType.MOUSE){
      MouseEvent m_evt = cast(MouseEvent) e;
      switch(m_evt.getBtn()){
        case MouseBtn.LEFT:
          if(m_evt.getType==KeyEventType.DOWN){
            if(heightmap.buffered){
              heightmap.buffered=false;
            }else{
              heightmap.buffer();
            }
          }
        break;
        default:break;
      }
    }
  }
  
  void render(GFXEngine engine){
    text.setText("Buffered: " ~ to!string(heightmap.buffered) ~ "");
    text.addLine("FPS: " ~ engine.fps);
  }
   
  private:
  HeightMap  heightmap;
  Text   text;
}
