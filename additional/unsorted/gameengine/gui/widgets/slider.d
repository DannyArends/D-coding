module gui.widgets.slider;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import core.events.engine;
import core.events.keyevent;

import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class Slider : DragBar{
  this(Object2D parent){
    super(0, 0, 100, 16,"",parent);
    init();
  }
  
  void init(){
    setBgColor(0.3,0.3,0.3);
    setRange(0,100);
    value = 0;
    getNameObject().location = [100,0,0];
    slider = new Square(0,0,16,16,this);
  }
  
  void setRange(int start, int stop){
    range[0] = start;
    range[1] = stop;
  }
  
  override void onClick(int cx, int cy){
    if(cx >= this.x() && (cx+16) <= (this.x()+this.sx())){
      slider.location = [cx-this.x(),0,0];
      setNewValue();
    }
    setName(to!string(value) ~ "");
    dragging = !dragging;
  }
  
  override void onDrag(int cx, int cy){
    if(dragging && (slider.x()+cx) >= this.x() && (slider.x()+cx+16) <= (this.x()+this.sx())){
      slider.move([cx,0,0]);
      setNewValue();
    }else{
      dragging = false;
    }
    setName(to!string(value) ~ "");
  }
  
  override void render(){
    super.render();
    slider.render();
  }
  
  void setNewValue(){
    value = to!int((((slider.x()-x())/(sx()-16))) * (range[1]-range[0])) + range[0];
  }
  
  override Event handleKeyPress(KeyEvent key){ return new Event(); }
  
  override Object2DType getType(){ return Object2DType.SLIDER; }
private:
  int[2]     range;
  int        value;
  Square     slider;
  bool       dragging = false;
}