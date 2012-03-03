/**********************************************************************
 * \file src/game/games/mapmove.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.games.mapmove;

import std.stdio;
import std.math;

import core.typedefs.types;
import core.arrays.algebra;

import io.events.engine;
import io.events.mouseevent;
import game.engine;
import gui.stdinc;
import sfx.engine;

class MapMove : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
    player = new Skeleton(100, -1, 100);
    cameraMotion(new ObjectMotion(screen,player));
    map = new HeightMap(0, -5, 0, screen.getTexture("map"));
    screen.add(map);
    screen.add(player);
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(GameEngine engine){
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
