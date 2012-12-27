module gui.widgets.windowbutton;

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

class WindowButton : Button{
  this(string btnname, Object2D parent){
    super(0,0, btnname.length*12+2, 16, btnname, parent);
  }
  
  override void onClick(int x, int y){
    writeln("OnClick of a window button");
//    getWindow().setVisible(false);
  }
  
  override void onDrag(int x, int y){ }
  override Event handleKeyPress(KeyEvent key){ return new Event(); }
  private:
}
