module gui.widgets.window;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.hud;
import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class Window : Object2D{
public:
  this(double x, double y, Hud hud){
    super(x,y,125,60,hud);
    init();
  }
  
  this(double x, double y, double sx, double sy, Hud hud){
    super(x,y,sx,sy,hud);
    init();
  }
  
  this(double x, double y, double sx, double sy){
    super(x,y,sx,sy);
  }
  
  void init(){
    bg = new Square(0,20,sx(),sy()-20,this);
    bg.setColor(0.75,0.75,0.75);
    DragBar top = new DragBar(this);
    top.setColor(0.0,0.0,0.5);
    top.addObject(new MinMaxButton(this));
    top.addObject(new CloseButton(this));
    addObject(top);
  }
  
  void render(){
    if(isVisible()){
      glLoadIdentity();
      glTranslatef(x(),y(),0.0f);
      glColor4f(r(), g(),  b(), alpha());
      if(isMinimized()){
        getObjects()[0].render();
      }else{
        bg.render();
        foreach(Object2D contentelement; getObjects()){
          contentelement.render();
        }
      }
    }
  }
  
  Object2DType getType(){ return Object2DType.WINDOW; }
  
private:
  Square      bg;
}
