module gui.widgets.serverbutton;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;
import sdl.sdlstructs;

import core.typedefs.basictypes;

import game.users.gameclient;

import gui.hud;
import gui.widgets.object2d;
import gui.widgets.window;
import gui.widgets.text;
import gui.widgets.textinput;
import gui.widgets.square;
import gui.widgets.button;

class ServerButton : Button{
  this(string btnname, Window window, GameClient net,string prefix){
    super(0,0, btnname.length*12+2, 16, btnname, window);
    network=net;
    sendprefix=prefix;
  }
  
  void onClick(int x, int y){
    writeln("OnClick of a server button");
    string attached;
    foreach(Object2D obj;getWindow().getObjects()){
      if(obj.getType == Object2DType.TEXTINPUT){
        TextInput tmp = cast(TextInput)obj;
        attached ~= "[" ~ tmp.getName() ~ ":" ~  tmp.getInput() ~ "]";
      }
    }
    network.send(sendprefix ~ attached);
  }
  
  void onDrag(int x, int y){ }
  void handleKeyPress(SDLKey key, bool shift){ }
private:
  GameClient network;
  string sendprefix;
}