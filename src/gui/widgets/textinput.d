module gui.widgets.textinput;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import core.typedefs.types;

import io.events.keyevent;

import gui.widgets.object2d;
import gui.widgets.window;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class TextInput : Button{

  this(Object2D window, int x = 0, int y = 0, int sx = 100, int sy = 16, string label = "", string value = ""){
    super(x, y, sx, sy,label,window);
    setBgColor(0.3,0.3,0.3);
    inputtext = new Text(1+label.length*15,1,value,this);
  }
  
  void onClick(int x, int y){
    input="";
    inputtext.setText(input);
  }
  
  void onDrag(int x, int y){ }
  
  void handleKeyPress(KeyEvent key){
    switch(key.getSDLkey()){
      case SDLK_RETURN:
        onClick(0,0);
        input = "";
      break;
      case SDLK_BACKSPACE:
        if(input.length > 0) input = input[0..($-1)];
      break;
      default:
        input ~= key.getKeyPress();
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
  Text   inputtext;
  int    max_chars=255;
}