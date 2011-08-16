module gui.widgets.button;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
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
    this.buttonname = btnname;
    this.name = new Text(1,1,btnname,this);
    bg = new Square(0,0,sx(),sy(),this);
    bg.setColor(0.50,0.50,0.50);
  }
  
  abstract void onClick(int x, int y);
  abstract void onDrag(int x, int y);
  abstract void handleKeyPress(SDLKey key, bool shift);
  
  void renderOnlyMe(){
    glLoadIdentity();
    glTranslatef(x(),y(),0.0f);
    glColor4f(r(), g(),  b(), alpha());
    bg.render();
    name.render();
  }
  
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
  
  Square getBackGround(){
    return bg;
  }
  
  Text getNameObject(){
    return name;
  }
  
  string getName(){
    return buttonname;
  }
  
  void setName(string btnname){
    name.setText(btnname);
  }
  
  void setSize(double sx, double sy, bool children = true){
    super.setSize(sx,sy,children);
    if(bg !is null) bg.setSize(sx,sy);
  }
  
  Object2DType getType(){ return Object2DType.BUTTON; }

private:
  string   buttonname;
  Square   bg;
  Text     name;
}


class CloseButton : Button{
  this(Window window){
    super(window.sx()-18,2,15,15,"X",window);
  }
  void onClick(int x, int y){
    writeln("OnClick of the CloseBtn");
    getWindow().setVisible(false);
  }
  
  void onDrag(int x, int y){ }
  void handleKeyPress(SDLKey key, bool shift){ }
}

class MinMaxButton : Button{
  this(Window window){
    super(window.sx()-36,2,15,15,"-",window);
  }
  
  void onClick(int x, int y){
    writeln("OnClick of the MinMaxBtn");
    getWindow().setMinimized(!getWindow().isMinimized());
  }
  
  void onDrag(int x, int y){ }
  void handleKeyPress(SDLKey key, bool shift){ }
}

class DragBar : Button{
  this(Window window){
    super(0,0,window.sx(),20,"",window);
    bg.setColor(0.0,0.0,0.5);
  }
  
  this(double x, double y, double sx, double sy, string btnname, Window window){
    super(x,y,sx,sy,"",window);
    bg.setColor(0.0,0.0,0.5);
  }
  
  void onClick(int x, int y){
    writeln("OnClick of the DragBar");
    getWindow().setDragging(!getWindow().isDragging());
  }
  
  void onDrag(int x, int y){ 
    if(getWindow().isDragging())getWindow().move(x,y,0);
  }
  
  void handleKeyPress(SDLKey key, bool shift){ }
  
  Object2DType getType(){ return Object2DType.DRAGBAR; }
}
