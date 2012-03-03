module gui.widgets.windowbutton;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import io.events.engine;
import io.events.keyevent;

import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class WindowButton : Button{
  this(string btnname, Object2D parent){
    super(0,0, btnname.length*12+2, 16, btnname, parent);
  }
  
  void onClick(int x, int y){
    writeln("OnClick of a window button");
//    getWindow().setVisible(false);
  }
  
  void onDrag(int x, int y){ }
  Event handleKeyPress(KeyEvent key){ return new Event(); }
  private:
}
