/******************************************************************//**
 * \file src/gui/screen.d
 * \brief Screen format definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.screen;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.gl_1_5;
import gl.gl_ext;

import core.typedefs.types;
import core.typedefs.camera;

import gui.engine;
import gui.widgets.object2d;
import gui.widgets.window;
import gui.widgets.text;
import gui.widgets.gamebutton;
import gui.objects.object3d;
import gui.objects.quad;
import gui.textureloader;
import gui.formats.tga;

import game.games.triggerpull;
import game.games.mapmove;
import game.games.empty;
import game.games.servergame;

import game.tests.objects2d;
import game.tests.lqt;
import game.tests.spheres;
import game.tests.heightmap;
import game.tests.liquid;
import game.tests.object3ds;
import game.tests.emission;

/*! \brief Rendering class for GFX objects
 *
 *  The Screen class is the main rendering class for GFX objects
 */
class Screen : Object2D{
  public:
    this(GFXEngine engine){
      super(0,0,engine.width,engine.height);
      this.engine = engine;
      this.camera = new Camera();
      textureloader = new TextureLoader();
      textureloader.load();
      fontID = textureloader.getTextureID("font");
      base = loadTextureAsFont(fontID);
    }
    
    void render3D(bool verbose = false){
      glLoadIdentity();
      glRotatef(camera.rx, 1.0, 0.0, 0.0);
      glRotatef(camera.ry, 0.0, 1.0, 0.0);
      glRotatef(camera.rz, 0.0, 0.0, 1.0);
      glTranslatef(camera.x,camera.y,camera.z);
      foreach(Object3D obj; objects3d){
        obj.render(obj.getFaceType());
      }
      if(verbose) writefln("[SCREEN] Rendered: %s objects", objects3d.length);
    }

    void render(){
      glMatrixMode(GL_PROJECTION);
      glLoadIdentity();
      glOrtho(0.0f, sx(), sy(), 0.0f, 0.0f, 1.0f);
      glMatrixMode(GL_MODELVIEW);
      glDisable(GL_DEPTH_TEST);
      foreach(Object2D obj; getObjects()){
        obj.render();
      }
    }
    
    void resize(int width, int height){
      setSize(width,height,false);
      textureloader.refreshAfterResize();
      fontID = textureloader.getTextureID("font");
      base = loadTextureAsFont(fontID);      
    }
    
    void showLoading(){
      Quad q = new Quad(1.5,-0.2,0);
      q.setRotation(0.0,-60.0,0.0);
      q.setTexture(textureloader.getTextureID("DGE"));
      q.setSize(2.0, 1.0, 1.0);
      q.setColor(1.0, 1.0, 1.0, 0.0);
      add(q);
    }
    
    void rotateLogo(int amount){
      if(objects3d.length == 1){
        objects3d[0].rotate(0.0,cast(double)amount,0.0);
      }
    }

    void changeLogo(string name){
      if(objects3d.length == 1){
        objects3d[0].setRotation(0.0,-60.0,0.0);
        (cast(Quad)objects3d[0]).setTexture(textureloader.getTextureID(name));
      }
    }
    
    void clear(){
      clearObjects();
      objects3d.length=0;
    }

    void showMainMenu(){
      addObject(new Text(100,100,"Menu",this));
      addObject(new GameButton(100,120,"Empty",engine.game,new Empty(),this));
      addObject(new GameButton(100,140,"Triggerpull",engine.game,new TriggerPull(),this));
      addObject(new GameButton(100,160,"MapMove",engine.game,new MapMove(),this));
      addObject(new GameButton(100,180,"ServerGame",engine.game,new ServerGame(),this));
      
      addObject(new Text(400,100,"Test",this));
      addObject(new GameButton(400,120,"2D objects",engine.game,new Test_Objects2D(),this));
      addObject(new GameButton(400,140,"Line Quad Triangle",engine.game,new Test_LQT(),this));
      addObject(new GameButton(400,160,"Spheres",engine.game,new Test_Spheres(),this));
      addObject(new GameButton(400,180,"Height map",engine.game,new Test_HeightMap(),this));
      addObject(new GameButton(400,200,"Liquid map",engine.game,new Test_Liquid(),this));
      addObject(new GameButton(400,220,"Object3DS",engine.game,new Test_Object3DS(),this));
      addObject(new GameButton(400,240,"Emission",engine.game,new Test_PE(),this));
    }

    void add(Object3D o){ objects3d ~= o; }
    void add(Object3D[] objects){ 
      foreach(Object3D obj;objects){ add(obj); }      
    }
    void add(Object2D o){ addObject(o); }
    
    @property int width(){ return engine.width; }
    @property int height(){ return engine.height; }

    
    GLuint getFontBase(){ return base; }
    Camera getCamera(){ return camera; }
    GLuint getFontId(){ return fontID; }
    GLuint getTextureID(string name){ return textureloader.getTextureID(name); }
    Texture getTexture(string name){ return textureloader.getTexture(name); }
    Object2DType getType(){ return Object2DType.SCREEN; }

private:
  GLuint        base;
  GLuint        fontID;
  Camera        camera;
  TextureLoader textureloader;  
  Object3D[]    objects3d;
  GFXEngine     engine;
}
