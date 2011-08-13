module gui.widgets.textinput;

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
import gui.widgets.button;

class TextInput : Button{
  this(Window window){
    super(0, 0, 200, 20,"",window);
    setBgColor(0.3,0.3,0.3);
  }
  
  void onClick(){ }
  
  void onDrag(int x, int y){ }
  
  void handleKeyPress(char c){
    
  }
  
  Object2DType getType(){ return Object2DType.TEXTINPUT; }
private:
  string input;
}