module gui.widgets.textinput;

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

class TextInput : Button{
  this(Window window, string label = "", string value = ""){
    super(0, 0, 200, 16,label,window);
    setBgColor(0.3,0.3,0.3);
    inputtext = new Text(1+label.length*15,1,value,this);
  }
  
  this(int x, int y, Window window, string label = "", string value = ""){
    super(x, y, window.sx(), 16,label,window);
    setBgColor(0.3,0.3,0.3);
    inputtext = new Text(1+label.length*15,1,value,this);
  }
  
  void onClick(int x, int y){
    input="";
    inputtext.setText(input);
  }
  
  void onDrag(int x, int y){ }
  
  void handleKeyPress(SDLKey key, bool shift){
    switch(key){
      case SDLK_RETURN:
        onClick(0,0);
        input = "";
      break;
      case SDLK_BACKSPACE:
        if(input.length > 0) input = input[0..($-1)];
      break;
      default:
        if((key & 0xFF80) == 0 ){
          char c = to!char(key & 0x7F);
          if(shift) c = toShiftChar(c);
          if(input.length < max_chars) input ~= c;
        }
      break;
    }
    inputtext.setText(input);
  }
  
  void render(){
    super.render();
    inputtext.render();
  }
  
  void setInputLength(int length){
    max_chars=length;
  }
  
  string getInput(){ return input; }
  Object2DType getType(){ return Object2DType.TEXTINPUT; }

private:
  string input;
  Text inputtext;
  int max_chars=255;
}