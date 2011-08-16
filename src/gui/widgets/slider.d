module gui.widgets.slider;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import core.typedefs.basictypes;

import gui.hud;
import gui.widgets.object2d;
import gui.widgets.window;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class Slider : DragBar{
  this(Window window){
    super(0, 0, 100, 16,"",window);
    init();
  }
  
  void init(){
    setBgColor(0.3,0.3,0.3);
    setRange(0,100);
    value = 0;
    this.getNameObject().setLocation(100,0,0);
    slider = new Square(0,0,16,16,this);
  }
  
  void setRange(int start, int stop){
    range[0] = start;
    range[1] = stop;
  }
  
  void onClick(int cx, int cy){
    if(cx >= this.x() && (cx+16) <= (this.x()+this.sx())){
      slider.setLocation(cx-this.x(),0,0);
      setNewValue();
    }
    setName(to!string(value) ~ "");
    dragging = !dragging;
  }
  
  void onDrag(int cx, int cy){
    if(dragging && (slider.x()+cx) >= this.x() && (slider.x()+cx+16) <= (this.x()+this.sx())){
      slider.move(cx,0,0);
      setNewValue();
    }else{
      dragging = false;
    }
    setName(to!string(value) ~ "");
  }
  
  void render(){
    super.render();
    slider.render();
  }
  
  void setNewValue(){
    value = to!int((((slider.x()-x())/(sx()-16))) * (range[1]-range[0])) + range[0];
  }
  
  void handleKeyPress(SDLKey key, bool shift){ }
  
  Object2DType getType(){ return Object2DType.SLIDER; }
private:
  int[2]     range;
  int        value;
  Square     slider;
  bool       dragging = false;
}