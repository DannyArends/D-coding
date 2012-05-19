/******************************************************************//**
 * \file src/game/games/mapmove.d
 * \brief Map move game definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.games.mapmove;

import std.stdio, std.math;

import core.typedefs.types;
import core.arrays.algebra;

import core.events.engine;
import core.events.mouseevent;
import game.engine;
import gui.stdinc;
import sfx.engine;

class MapMove : Game{
  public:
  override void setup2D(Screen screen){
    writefln("[ G ] setup2D");
  }

  override void setup3D(Screen screen){
    writefln("[ G ] setup3D");
    player = new Skeleton(100, -1, 100);
    cameraMotion(new ObjectMotion(screen,player));
    map = new HeightMap(0, -5, 0, screen.getTexture("map"));
    screen.add(map);
    screen.add(player);
  }
  
  override void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  override void quit(){
    writefln("[ G ] quit");
  }
  
  override void load(){
    writefln("[ G ] load");
    map.buffer();
  }
  
  override void save(){
    writefln("[ G ] save");
  }
  
  override void render(GFXEngine engine){

  }
  
  override void handle(Event e){
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
