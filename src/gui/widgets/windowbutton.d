module gui.widgets.windowbutton;

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
import gui.widgets.textinput;
import gui.widgets.square;
import gui.widgets.button;

class WindowButton : Button{
  this(string btnname, Window window){
    super(0,0, btnname.length*12+2, 16, btnname, window);
  }
  
  void onClick(int x, int y){
    writeln("OnClick of a window button");
  }
  
  void onDrag(int x, int y){ }
  void handleKeyPress(SDLKey key, bool shift){ }
private:
}