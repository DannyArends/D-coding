/******************************************************************//**
 * \file src/game/tests/heightmap.d
 * \brief Height map test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.heightmap;

import std.stdio, std.conv;
import core.typedefs.types, core.events.engine, core.events.mouseevent;
import game.engine, game.games.empty, gui.stdinc, sfx.engine;

class Test_HeightMap : Empty{
  public:
  override void setup2D(Screen screen){ super.setup2D(screen);
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  
  override void setup3D(Screen screen){ super.setup3D(screen);
    cameraMotion(new FPMotion(screen));
    wGAME("Done with 3D motion setup");
    Texture map = screen.getTexture("map");
    heightmap = new HeightMap(-50, -10,-100, map);
    heightmap.rotate([0,20,0]);
    screen.add(heightmap);
  }
  
  override void load(){
    heightmap.buffer();
  }
  
  override void handle(Event e){
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
  
  override void render(GFXEngine engine){
    text.setText("Buffered: " ~ to!string(heightmap.buffered) ~ "");
    text.addLine("FPS: " ~ engine.fps);
  }
   
  private:
    HeightMap  heightmap;
    Text   text;
}
