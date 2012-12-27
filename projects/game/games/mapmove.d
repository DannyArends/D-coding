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
import core.typedefs.types, core.arrays.algebra;
import core.events.engine, core.events.mouseevent, game.engine;
import game.games.empty, gui.stdinc, sfx.engine;

class MapMove : Empty{
  public:

  override void setup3D(Screen screen){ super.setup3D(screen);
    player = new Skeleton(100, -1, 100);
    cameraMotion(new ObjectMotion(screen,player));
    map = new HeightMap(0, -5, 0, screen.getTexture("map"));
    screen.add(map);
    screen.add(player);
  }

  override void load(){ super.load(); 
    map.buffer();
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
