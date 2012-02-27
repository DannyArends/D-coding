/******************************************************************//**
 * \file src/gui/widgets/object2d.d
 * \brief 2D object definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.widgets.object2d;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;
import core.typedefs.color;
import core.typedefs.location;

enum Object2DType{SQUARE, WINDOW, BUTTON, DRAGBAR, TEXTINPUT, SLIDER, TEXT, SCREEN};

/*! \brief Abstract 2D Object
 *
 *  Abstract 2D Object class
 */
abstract class Object2D : Location{
  this(Object2D parent = null){
    this(0.0, 0.0, 1.0, 1.0, parent);
  }
  
  this(double x, double y, Object2D parent = null){
    this(x, y, 1.0, 1.0, parent);
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
  bool isScreen(){ return(this.getType()==Object2DType.SCREEN); }
  void setVisible(bool v){ visible = v; }
  bool isMinimized(){ return minimized; }
  void setMinimized(bool m){ this.minimized = m; }
  void setDragging(bool d){ this.dragging = d; }
  bool isDragging(){return this.dragging; }
  Object2D[] getObjects(){return objects;}
  void clearObjects(){objects.length=0;}

  @property GLfloat r(){ return color.r(); }
  @property GLfloat g(){ return color.g(); }
  @property GLfloat b(){ return color.b(); }
  @property GLfloat alpha(){ return color.alpha(); }
  
  @property GLfloat x(){
    if(isScreen()) return 0.0;
    if(getParent().isScreen()){
      return super.x(); 
    }else{
      return super.x() + getParent.x();
    }
  }
  
  @property GLfloat y(){ 
    if(isScreen()) return 0.0;
    if(getParent().isScreen()){
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
  
  Object2D getWindow(){
    if(parent.getType()==Object2DType.WINDOW){
      return parent;
    }
    return parent.getWindow();
  }
  
  Object2D getObjectAt(int cx, int cy){
    //writefln("x: %f %f",x()+sx(),y()+sy());
    if(visible && x() < cx && y() < cy && x()+sx() > cx && y()+sy() > cy){
      if(objects != null){
        foreach(Object2D obj; objects){
          if(obj.x() < cx && obj.y() < cy){
          //  writefln("x: %f %f %d",obj.x(),obj.sx(), cx);
          //  writefln("y: %f %f %d",obj.y(),obj.sy(), cy);
            if((obj.x()+obj.sx()) > cx && (obj.y()+obj.sy()) > cy){
              Object2D subobj = obj.getObjectAt(cx,cy);
              if(subobj !is null) return subobj;
            }
          }
        }
      }else{
        //writeln("No objects");
      }
      return this;
    }
    return null;
  }
  
  void setTexture(int id){ textureid=id; }
  int getTexture(){ return textureid; }
  
  void resize(int width, int height){ }
  
  @property GLfloat sx(){ return size[0]; }
  @property GLfloat sy(){ return size[1]; }
private:
  Object2D    parent;
  Object2D[]  objects;
  Color       color;
  double[2]   size;
  bool        visible = true;
  bool        minimized = false;
  bool        dragging = false;
  int       textureid  = -1;
}
