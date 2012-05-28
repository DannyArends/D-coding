/******************************************************************//**
 * \file src/game/tests/object3ds.d
 * \brief Object3DS test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.object3ds;

import std.stdio, std.conv, sfx.engine;
import core.typedefs.types, core.events.engine;
import game.engine, game.games.empty, gui.stdinc;

class Test_Object3DS : Empty{
  public:
  override void setup2D(Screen screen){ super.setup2D(screen);
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){ super.setup3D(screen);
    cameraMotion(new FPMotion(screen));
    wGAME("Done with 3D motion setup");
    objects ~= new Model3DS(-3, -1,-8,"data/objects/object_3.3ds");
    objects ~= new Skeleton(-1, -1,-5);
    //objects[0].buffer();
    screen.add(objects);
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  private:
  Object3D[] objects;
  Text       text;
}
