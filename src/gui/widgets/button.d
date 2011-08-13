module gui.widgets.button;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.hud;
import gui.widgets.object2d;
import gui.widgets.window;
import gui.widgets.text;
import gui.widgets.square;

class Button : Object2D{
public:
  this(double x, double y, string btnname, Object2D parent){
    super(x, y, 125, 16, parent);
    init(btnname);
  }
  
  this(double x, double y, double sx, double sy, string btnname, Object2D parent){
    super(x, y, sx, sy, parent);
    init(btnname);
  }
  
  void init(string btnname){
    this.name = new Text(1,1,btnname,this);
    bg = new Square(0,0,sx(),sy(),this);
    bg.setColor(0.50,0.50,0.50);
  }
  
  abstract void onClick();
  abstract void onDrag(int x, int y);
  abstract void handleKeyPress(char c);
  
  void render(){
    glLoadIdentity();
    glTranslatef(x(),y(),0.0f);
    glColor4f(r(), g(),  b(), alpha());
    bg.render();
    name.render();
    foreach(Object2D obj; getObjects()){
      obj.render();
    }
  }
  
  void setBgColor(double r,double g,double b){
    bg.setColor(r,g,b);
  }
  
  Object2DType getType(){ return Object2DType.BUTTON; }

private:
  Square   bg;
  Text     name;
}


class CloseButton : Button{
  this(Window window){
    super(window.sx()-18,2,15,15,"X",window);
  }
  void onClick(){
    writeln("OnClick of the CloseBtn");
    getWindow().setVisible(false);
  }
  
  void onDrag(int x, int y){ }
  void handleKeyPress(char c){ }
}

class MinMaxButton : Button{
  this(Window window){
    super(window.sx()-36,2,15,15,"-",window);
  }
  
  void onClick(){
    writeln("OnClick of the MinMaxBtn");
    getWindow().setMinimized(!getWindow().isMinimized());
  }
  
  void onDrag(int x, int y){ }
  void handleKeyPress(char c){ }
}

class DragBar : Button{
  this(Window window){
    super(0,0,window.sx(),20,"",window);
    bg.setColor(0.0,0.0,0.5);
  }
  
  void onClick(){
    writeln("OnClick of the DragBar");
    getWindow().setDragging(!getWindow().isDragging());
  }
  
  void onDrag(int x, int y){ 
    if(getWindow().isDragging())getWindow().move(x,y,0);
  }
  
  void handleKeyPress(char c){ }
  
  Object2DType getType(){ return Object2DType.DRAGBAR; }
}
