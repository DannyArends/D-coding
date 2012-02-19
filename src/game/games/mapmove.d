module game.games.mapmove;

import std.stdio;
import std.math;

import core.arrays.algebra;

import io.events.engine;
import io.events.mouseevent;
import game.engine;
import gui.engine;
import gui.screen;
import gui.motion;
import gui.objects.surface;
import gui.objects.skeleton;
import sfx.engine;

class MapMove : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
    player = new Skeleton(100, -1, 100);
    setCameraMotion(new ObjectMotion(screen,player));
    map = new HeightMap(0, -5, 0, screen.getTexture("map"));
    screen.add(map);
    screen.add(player);
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(){
    writefln("[ G ] quit");
  }
  
  void load(GameEngine engine){
    writefln("[ G ] load");
    map.buffer();
  }
  
  void save(){
    writefln("[ G ] save");
  }
  
  void render(GFXEngine engine){

  }
  
  void handle(Event e){
    if(e.getEventType() == EventType.MOUSE){
      MouseEvent m_evt = cast(MouseEvent) e;
      switch(m_evt.getBtn()){
        case MouseBtn.LEFT:
          double w_loc[3] = m_evt.getXYZ();
          map.setHighlight(cast(int)(w_loc[0]),cast(int)(w_loc[2]));
          e.handled=true;
        break;
        default:break;
      }
    }
  }
  
  private:
    Skeleton  player;
    HeightMap map;
}