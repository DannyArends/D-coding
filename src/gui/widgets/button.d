module gui.widgets.button;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gl.gl_1_1;

import gui.hud;
import gui.widgets.object2d;
import gui.widgets.text;
import gui.widgets.square;

class Button : Object2D{
public:
  this(double x, double y, string name, Object2D parent){
    super(x, y, 125, 16, parent);
    this.name = name;
    bg = new Square(0,0,125,16,this);
    bg.setColor(0.50,0.50,0.50);
  }
  
  this(double x, double y, double sx, double sy, string name, Object2D parent){
    super(x, y, sx, sy, parent);
    this.name = name;
    bg = new Square(0,0,sx,sy,this);
    bg.setColor(0.50,0.50,0.50);
  }
  
  void onClick(){
    
  }
  
  void onDrag(){
    
  }
  
  void render(){
    glLoadIdentity();
    glTranslatef(x(),y(),0.0f);
    glColor4f(r(), g(),  b(), alpha());
    bg.render();
  }

private:
  Square   bg;
  string   name;
}
