/******************************************************************//**
 * \file src/gui/widgets/textinput.d
 * \brief 2D widget for text input definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.widgets.textinput;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import core.typedefs.types;

import io.events.engine;
import io.events.keyevent;
import io.events.networkevent;

import gui.stdinc;

class TextInput : Button{

  this(Object2D window, int x = 0, int y = 0, int sx = 100, int sy = 16, string label = "", string value = ""){
    super(x, y, sx, sy,label,window);
    setBgColor(0.3,0.3,0.3);
    inputtext = new Text(this,1+label.length*15,1,value);
  }
  
  void onClick(int x, int y){
    input="";
    inputtext.setText(input);
  }
  
  void onDrag(int x, int y){ }
  
  Event handleKeyPress(KeyEvent key){
    Event e = new Event();
    switch(key.getSDLkey()){
      case SDLK_RETURN:
        e = new NetworkEvent(NetEvent.CHAT ~ input ~ "\0", false);
        onClick(0,0);
      break;
      case SDLK_BACKSPACE:
        if(input.length > 0) input = input[0..($-1)];
      break;
      default:
        input ~= key.getKeyPress();
      break;
    }
    inputtext.setText(input);
    return e;
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
