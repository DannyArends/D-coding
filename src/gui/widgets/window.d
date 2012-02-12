module gui.widgets.window;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class Window : Object2D{
public:
  this(double x, double y, Object2D parent, bool menuBar = true){
    this(x, y, 125, 60, parent, menuBar);
  }
  
  this(double x, double y, double sx, double sy, Object2D parent, bool menuBar = true){
    super(x,y,sx,sy,parent);
    bg = new Square(0,20,sx,sy-20,this);
    bg.setColor(0.75,0.75,0.75);
    if(menuBar) initMenuBar();
  }
  
  void initMenuBar(){
    top = new DragBar(this);
    top.setColor(0.0,0.0,0.5);
    top.addObject(new MinMaxButton(this));
    top.addObject(new CloseButton(this));
    addObject(top);
  }
  
  void render(){
    if(isVisible()){
      glLoadIdentity();
      glTranslatef(x,y,0.0f);
      glColor4f(r, g,  b, alpha);
      if(isMinimized()){
        if(top !is null) top.render();
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
  DragBar     top;
  Square      bg;
  bool        hasTop = true;
}
