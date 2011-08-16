module gui.widgets.object2d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import gui.objects.color;
import gui.objects.location;
import gui.widgets.window;

enum Object2DType{SQUARE, WINDOW, BUTTON, DRAGBAR, TEXTINPUT, SLIDER, TEXT, HUD};

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
  
  void setParent(Object2D p){
    parent = p;
  }
  
  Object2D getParent(){
    return parent;
  }
  
  Window getWindow(){
    if(parent !is null){
      if(parent.getType()==Object2DType.WINDOW){
        return cast(Window)parent;
      }else{
        return parent.getWindow();
      }
    }
    return null;
  }
    
  void setSize(double sx, double sy, bool children = true){
    size[0]=sx;
    size[1]=sy;
    if(children){
      foreach(Object2D o; objects){ o.setSize(sx,sy); }
    }
  }
  
  void setMySize(double sx, double sy){
    setSize(sx,sy,false);
  }
  
  void setColor(double r, double g, double b, double a = 1.0){
    if(color is null){
      color = new Color(r,g,b,a);
    }else{
      color.setColor(r,g,b,a);
    }
  }
  
  abstract void render();
  abstract Object2DType getType();
  
  GLuint getFontBase(){ return getParent().getFontBase(); }
  GLuint getFontId(){ return getParent().getFontId(); }
  
  bool isVisible(){ return visible; }
  bool isHud(){ return false; }
  void setVisible(bool v){ visible = v; }
  bool isMinimized(){ return minimized; }
  void setMinimized(bool m){ this.minimized = m; }
  void setDragging(bool d){ this.dragging = d; }
  bool isDragging(){return this.dragging; }
  Object2D[] getObjects(){return objects;}

  GLfloat r(){ return color.r(); }
  GLfloat g(){ return color.g(); }
  GLfloat b(){ return color.b(); }
  GLfloat alpha(){ return color.alpha(); }
  
  GLfloat x(){
    if(isHud()) return 0.0;
    if(getParent().isHud()){
      return super.x(); 
    }else{
      return super.x() + getParent.x();
    }
  }
  
  GLfloat y(){ 
    if(isHud()) return 0.0;
    if(getParent().isHud()){
      return super.y(); 
    }else{
      return super.y() + getParent.y();
    }
  }
  
  void addContent(Object2D object){
    object.setParent(this);
    if((this.sx()-2) <= object.sx()){
      object.setSize(this.sx()-2,object.sy());
    }else{
      object.setSize(object.sx(),object.sy());
    }
    double toshift=1;
    foreach(Object2D o;objects){
      toshift+=o.sy()+1;
    }
    object.setLocation(1,toshift,0);
    objects ~= object;
  }
  
  void addObject(Object2D object){
    objects ~= object;
  }
  
  Object2D getObjectAt(int cx, int cy){
    //writefln("x: %f %f",x()+sx(),y()+sy());
    if(visible && x() < cx && y() < cy && x()+sx() > cx && y()+sy() > cy){
      if(objects != null){
        foreach(Object2D obj; objects){
          if(obj.x() < cx && obj.y() < cy){
            //writefln("x: %f %f %d",obj.x(),obj.sx(), cx);
            //writefln("y: %f %f %d",obj.y(),obj.sy(), cy);
            if((obj.x()+obj.sx()) > cx && (obj.y()+obj.sy()) > cy){
              return obj.getObjectAt(cx,cy);
            }
          }
        }
      }
      return this;
    }
    return null;
  }
  
  void resize(int width, int height){ }
  
  GLfloat sx(){ return size[0]; }
  GLfloat sy(){ return size[1]; }
private:
  Object2D    parent;
  Object2D[]  objects;
  Color       color;
  double[2]   size;
  bool        visible = true;
  bool        minimized = false;
  bool        dragging = false;
};
