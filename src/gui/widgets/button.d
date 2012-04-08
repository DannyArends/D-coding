/******************************************************************//**
 * \file src/gui/widgets/button.d
 * \brief 2D button definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.widgets.button;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
import gl.gl_1_0;
import gl.gl_1_1;

import core.events.engine;
import core.events.keyevent;

import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;

/*! \brief 2D button definition
 *
 * Definition of a generic 2D widget: The Button class is the parent class of 
 * all clickable 2D widgets (e.g. Slider, TextInput, Window).
 */
class Button : Object2D{
public:
  this(double x, double y, string btnname, Object2D parent){
    this(x, y, 125, 16, btnname, parent);
  }
  
  this(double x, double y, double sx, double sy, string btnname, Object2D parent){
    super(x, y, sx, sy, parent);
    buttonname = btnname;
    name = new Text(this,1,1,btnname);
    bg = new Square(0,0,sx,sy,this);
    bg.setColor(0.50,0.50,0.50);
  }
  
  abstract void  onClick(int x, int y);
  abstract void  onDrag(int x, int y);
  abstract Event handleKeyPress(KeyEvent key);
  
  override void render(){
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
    buttonname = btnname;
    name.setText(btnname);
  }
  
  override void setSize(double sx, double sy, bool children = true){
    super.setSize(sx,sy,children);
    if(bg !is null) bg.setSize(sx,sy);
  }
  
  override Object2DType getType(){ return Object2DType.BUTTON; }

private:
  string   buttonname;
  Square   bg;
  Text     name;
}

class CloseButton : Button{
  this(Object2D parent){
    super(parent.sx()-18,2,15,15,"X",parent);
  }
  
  override void onClick(int x, int y){
    writeln("OnClick of the CloseBtn");
    getWindow().setVisible(false);
  }
  
  override void onDrag(int x, int y){ }
  override Event handleKeyPress(KeyEvent key){ return new Event(); }
}

class MinMaxButton : Button{
  this(Object2D parent){
    super(parent.sx()-36,2,15,15,"-",parent);
  }
  
  override void onClick(int x, int y){
    writeln("OnClick of the MinMaxBtn");
    getWindow().setMinimized(!getWindow().isMinimized());
  }
  
  override void onDrag(int x, int y){ }
  override Event handleKeyPress(KeyEvent key){ return new Event(); }
}

class DragBar : Button{
  this(Object2D parent){
    super(0,0,parent.sx(),20,"",parent);
    bg.setColor(0.0,0.0,0.5);
  }
  
  this(double x, double y, double sx, double sy, string btnname, Object2D parent){
    super(x,y,sx,sy,"",parent);
    bg.setColor(0.0,0.0,0.5);
  }
  
  override void onClick(int x, int y){
    writeln("OnClick of the DragBar");
    getWindow().setDragging(!getWindow().isDragging());
  }
  
  override void onDrag(int x, int y){ 
    if(getWindow().isDragging())getWindow().move(x,y,0);
  }
  
  override Event handleKeyPress(KeyEvent key){ return new Event(); }
  
  override Object2DType getType(){ return Object2DType.DRAGBAR; }
}
