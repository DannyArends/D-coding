/******************************************************************//**
 * \file src/game/tests/emission.d
 * \brief Emission test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jul, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.emission;

import std.stdio, std.string, std.conv, std.file;
import core.events.engine, core.events.mouseevent;
import game.engine, game.games.empty;
import gui.stdinc, gui.widgets.text;
import sfx.engine;

class Test_PE : Empty{
  public:
  override void setup2D(Screen screen){ super.setup2D(screen);
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){ super.setup3D(screen);
    cameraMotion(new FPMotion(screen));
    wGAME("Done with 3D motion setup");
    object = new PE(-50, -10,-100);
    object.addForce(new Gravity());
    screen.add(object);
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  override void update(){
    object.update();
  }
  
  private:
    PE object;
    Text   text;
}
