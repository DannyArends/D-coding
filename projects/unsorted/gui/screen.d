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

import std.array, std.stdio, std.conv;
import gl.gl_1_0, gl.gl_1_1, gl.gl_1_5, gl.gl_ext;
import core.arrays.search, core.terminal;
import core.typedefs.types, core.typedefs.camera;

import gui.engine;
import gui.widgets.object2d, gui.widgets.window, gui.widgets.text;
import gui.widgets.gamebutton, gui.objects.object3d, gui.objects.quad;
import gui.textureloader, gui.formats.tga;

import game.games.triggerpull, game.games.mapmove;
import game.games.empty, game.games.servergame;

import game.tests.objects2d, game.tests.lqt;
import game.tests.spheres, game.tests.heightmap;
import game.tests.liquid, game.tests.object3ds;
import game.tests.emission;

mixin(GenOutput!("SCR", "Green"));

struct SceneObject{
  string   name;
  Object3D object3d;
}

/*! \brief Rendering class for GFX objects
 *
 *  The Screen class is the main rendering class for GFX objects
 */
class Screen : Object2D{
  public:
    this(GFXEngine engine){
      super(0,0,engine.width,engine.height);
      wSCR("Screen constructor starting");
      this.engine = engine;
      this.camera = new Camera();
      textureloader = new TextureLoader();
      textureloader.load();
      fontID = textureloader.getTextureID(fontname);
      wSCR("Loaded font '%s:%s'", fontname, fontID);
      base = loadTextureAsFont(fontID);
      wSCR("Done with screen constructor");
    }
    
    void render3D(bool verbose = false){
      glLoadIdentity();
      glRotatef(camera.rx, 1.0, 0.0, 0.0);
      glRotatef(camera.ry, 0.0, 1.0, 0.0);
      glRotatef(camera.rz, 0.0, 0.0, 1.0);
      glTranslatef(camera.x,camera.y,camera.z);
      foreach(SceneObject sceneobj; sceneobjects){
        Object3D obj = sceneobj.object3d;
        obj.render(obj.getFaceType());
      }
      if(verbose) wSCR("Rendered: %s objects", sceneobjects.length);
    }

    override void render(){
      glMatrixMode(GL_PROJECTION);
      glLoadIdentity();
      glOrtho(0.0f, sx(), sy(), 0.0f, 0.0f, 1.0f);
      glMatrixMode(GL_MODELVIEW);
      glDisable(GL_DEPTH_TEST);
      foreach(Object2D obj; getObjects()){
        obj.render();
      }
    }
    
    override void resize(int width, int height){
      setSize(width,height,false);
      textureloader.refreshAfterResize();
      fontID = textureloader.getTextureID("font");
      base = loadTextureAsFont(fontID);      
    }
    
    void showLoading(){
      Quad q = new Quad(1.5,-0.2,0);
      q.direction = [0.0, -60.0, 0.0];
      q.setTexture(textureloader.getTextureID("DGE"));
      q.setSize(2.0, 1.0, 1.0);
      q.setColor(1.0, 1.0, 1.0, 0.0);
      add(q,"logo");
    }
    
    void rotateLogo(int amount){
      size_t logoidx = getIndex("logo");
      if(logoidx != -1){
        sceneobjects[logoidx].object3d.rotate([0.0,cast(double)amount,0.0]);
      }
    }

    void changeLogo(string name){
      size_t logoidx = getIndex("logo");
      if(logoidx != -1){
        Quad logo = cast(Quad) sceneobjects[logoidx].object3d;
        logo.direction = [0.0, -60.0, 0.0];
        logo.setTexture(textureloader.getTextureID(name));
        sceneobjects[logoidx].object3d = logo;
      }
    }
    
    void clear(){
      clearObjects();
      sceneobjects.length=0;
    }

    void showMainMenu(){
      addObject(new Text(this, 100, 100, "Menu"));
      addObject(new GameButton(100,120,"Empty",engine.game,new Empty(),this));
      addObject(new GameButton(100,140,"Triggerpull",engine.game,new TriggerPull(),this));
      addObject(new GameButton(100,160,"MapMove",engine.game,new MapMove(),this));
      addObject(new GameButton(100,180,"ServerGame",engine.game,new ServerGame(),this));
      
      addObject(new Text(this, 400, 100, "Test"));
      addObject(new GameButton(400,120,"2D objects",engine.game,new Test_Objects2D(),this));
      addObject(new GameButton(400,140,"Line Quad Triangle",engine.game,new Test_LQT(),this));
      addObject(new GameButton(400,160,"Spheres",engine.game,new Test_Spheres(),this));
      addObject(new GameButton(400,180,"Height map",engine.game,new Test_HeightMap(),this));
      addObject(new GameButton(400,200,"Liquid map",engine.game,new Test_Liquid(),this));
      addObject(new GameButton(400,220,"Object3DS",engine.game,new Test_Object3DS(),this));
      addObject(new GameButton(400,240,"Emission",engine.game,new Test_PE(),this));
    }

    size_t getIndex(string name){
      for(size_t x=0; x < sceneobjects.length; x++){
        if(sceneobjects[x].name is name) return x;
      }
      return -1;
    }
    
    void reset3D(){
      sceneobjects.length = 0;    
    }
    
    void remove(string name){
      size_t idx = getIndex(name);
      sceneobjects = removearray(sceneobjects,idx);
      writeln(idx);
    }
    
    void add(Object3D o, string name = ""){ 
      sceneobjects ~= SceneObject(name, o); 
    }
    
    void add(Object3D[] objects){ 
      foreach(Object3D obj;objects){ add(obj); }      
    }
    
    void add(Object2D o){ addObject(o); }
    
    @property int width(){ return engine.width; }
    @property int height(){ return engine.height; }
    
    override GLuint getFontBase(){ return base; }
    Camera getCamera(){ return camera; }
    override GLuint getFontId(){ return fontID; }
    GLuint getTextureID(string name){ return textureloader.getTextureID(name); }
    Texture getTexture(string name){ return textureloader.getTexture(name); }
    override Object2DType getType(){ return Object2DType.SCREEN; }

private:
  GLuint        base;
  string        fontname = "font";
  GLuint        fontID;
  Camera        camera;
  TextureLoader textureloader;  
  SceneObject[] sceneobjects;
  GFXEngine     engine;
}
