module game.tests.spheres;

import std.stdio;
import std.conv;

import core.typedefs.types;
import io.events.engine;
import game.engine;
import game.games.empty;
import gui.engine;
import gui.screen;
import gui.motion;
import gui.objects.sphere;
import gui.objects.object3d;
import gui.widgets.text;
import sfx.engine;

class Test_Spheres : Empty{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(10,10,"",screen);
    screen.add(text);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
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
    setCameraMotion(new ObjectMotion(screen,spheres[2],30));
  }
  
  void render(GFXEngine engine){
    text.setText("FPS: " ~ to!string(engine.getFPS()));
  }
  
  private:
    Object3D[] spheres;
    Text   text;
}
