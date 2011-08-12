module gui.widgets.window;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.hud;
import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;
import gui.widgets.button;

class Window : Object2D{
public:
  this(double x, double y, Hud hud){
    super(x,y,125,60,hud);
    top = new Square(0,0,125,18,this);
    top.setColor(0.0,0.0,0.5);
    bg = new Square(0,18,125,50,this);
    bg.setColor(0.25,0.25,0.25);
    topbuttons[0] = new Button(84,2,10,10,"-",this);
    topbuttons[1] = new Button(98,2,10,10,"[]",this);
    topbuttons[2] = new Button(112,2,10,10,"X",this);
  }
  
  void addContent(Object2D object){
    object.setParent(this);
    object.move(0,20+20*content.length,0);
    content ~= object;
  }
  
  void render(){
    glLoadIdentity();
    glTranslatef(x(),y(),0.0f);
    glColor4f(r(), g(),  b(), alpha());
    top.render();
    bg.render();
    foreach(Button btn; topbuttons){
      btn.render();
    }
    foreach(Object2D contentelement; content){
      contentelement.render();
    }
  }

private:
  Square      bg;
  Square      top;
  Button[3]   topbuttons;
  Object2D[]  content;
}
