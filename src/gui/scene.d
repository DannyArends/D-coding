module gui.scene;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdl;
import sdl.sdlstructs;
import sdl.sdlfunctions;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.gl_1_5;
import gl.gl_ext;

import gui.engine;
import gui.objects.box;
import gui.objects.camera;
import gui.objects.line;
import gui.objects.model3ds;
import gui.objects.object3d;
import gui.objects.quad;
import gui.objects.sphere;
import gui.objects.surface;
import gui.objects.triangle;

class Scene{
  
  this(Engine e, Camera c){
    engine = e;
    camera = c;
  }
  
  void createNewChar(){
    Surface s = new Surface(0,-0.2,0);
    /*for(int x=0;x<10;x++){
      for(int y=0;y<10;y++){
        Triangle t = new Triangle();
        t.adjustSize(0.5);
        t.rotate(x,y*2,x*3);
        t.setColor(cast(float)(x)/10.0,cast(float)(y)/20.0,0);
        s.addObject(x+7,y*2,t);
      }
    }
    s.addObject(2,2,new Model3DS("data/objects/object_4.3ds"));*/
    objects ~= s;
  }
  
  void homeMap(){
    
  }
  
  void gameMap(string name){
    
  }
  
  void render(){
    foreach(Object3D o; objects){
     o.render(camera, o.getFaceType());
    }
  }
  
  void addObject(Object3D object){
    objects ~= object;
  }
  
private:
  Engine              engine;
  Camera              camera;
  Object3D[]          objects;
}
