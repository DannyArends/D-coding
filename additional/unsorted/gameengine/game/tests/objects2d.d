/******************************************************************//**
 * \file src/game/tests/object2d.d
 * \brief Object2D test class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.tests.objects2d;

import std.stdio, std.conv, sfx.engine;
import core.typedefs.types, core.events.engine;
import game.engine, game.games.empty, gui.stdinc;

class Test_Objects2D : Empty{
  public:
  override void setup2D(Screen screen){ super.setup2D(screen);
    text = new Text(screen, 10, 10);
    gun = new Square(0,200,300,300,screen);
    gun.setTexture(screen.getTextureID("Gun1"));
    target = new Square(400,50,200,240,screen);
    target.setTexture(screen.getTextureID("Target"));

    screen.add(text);
    screen.add(gun);
    screen.add(target);
  }
  
  override void render(GFXEngine engine){
    text.setText("FPS: " ~ engine.fps);
  }

  private:
    Text   text;
    Square gun;
    Square target;
}
