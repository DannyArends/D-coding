/******************************************************************//**
 * \file src/game/tests/spheres.d
 * \brief Sphere object test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.spheres;

import std.stdio, std.conv, sfx.engine;
import core.typedefs.types, core.events.engine;
import game.engine, game.games.empty, gui.stdinc;

class Test_Spheres : Empty{
  public:
  override void setup2D(Screen screen){ super.setup2D(screen);
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){ super.setup3D(screen);
    Texture map = screen.getTexture("map");
    spheres ~= new Sphere(-50, -10,-100);
    spheres ~= new Sphere(0, 0,-30);
    spheres ~= new Sphere(-30, 5,-30);
    spheres[0].setSize(1,1,1);
    spheres[1].setSize(4,4,1);
    spheres[1].setTexture(screen.getTextureID("Grass"));
    spheres[2].setSize(20,20,20);
    spheres[2].setTexture(screen.getTextureID("sky"));
    screen.add(spheres);
    cameraMotion(new ObjectMotion(screen,spheres[2],40));
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }
  
  private:
    Object3D[] spheres;
    Text   text;
}
