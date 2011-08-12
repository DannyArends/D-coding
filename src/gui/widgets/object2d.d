module gui.widgets.object2d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.color;
import gui.objects.location;

abstract class Object2D : Location{
  this(Object2D parent = null){
    super(0.0, 0.0, 0.0);
    setSize(1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
    setParent(parent);
  }
  
  this(double x, double y, Object2D parent = null){
    super(x, y, 0.0);
    setSize(1.0, 1.0);
    setColor(1.0, 1.0, 1.0);
    setParent(parent);
  }
  
  this(double x, double y, double sx, double sy, Object2D parent = null){
    super(x, y, 0.0);
    setSize(sx, sy);
    setColor(1.0, 1.0, 1.0);
    setParent(parent);
  }
  
  void setParent(Object2D parent){
    this.parent = parent;
  }
  
  Object2D getParent(){
    return this.parent;
  }
    
  void setSize(double sx, double sy){
    size[0]=sx;
    size[1]=sy; 
  }
  
  void setColor(double r, double g, double b, double a = 1.0){
    if(color is null){
      color = new Color(r,g,b,a);
    }else{
      color.setColor(r,g,b,a);
    }
  }
  
  abstract void render();
  
  
  GLuint getFontBase(){ return getParent().getFontBase(); }
  GLuint getFontId(){ return getParent().getFontId(); }
  
  bool isVisible(){ return visible; }
  bool isHud(){ return false; }
  void setVisible(bool v){ visible = v; }

  GLfloat r(){ return color.r(); }
  GLfloat g(){ return color.g(); }
  GLfloat b(){ return color.b(); }
  GLfloat alpha(){ return color.alpha(); }
  
  GLfloat x(){ 
    if(getParent().isHud()){
      return super.x(); 
    }else{
      return super.x() + getParent.x();
    }
  }
  
  GLfloat y(){ 
    if(getParent().isHud()){
      return super.y(); 
    }else{
      return super.y() + getParent.y();
    }
  }
  
  GLfloat sx(){ return size[0]; }
  GLfloat sy(){ return size[1]; }
private:
  Object2D   parent;
  Color      color;
  double[2]  size;
  bool       visible;
};
