/**********************************************************************
 * \file src/gui/objects/surface.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.surface;

import std.stdio;
import std.conv;
import std.math;
import std.random;

import gl.gl_1_0;
import gl.gl_1_1;

import core.arrays.types;
import core.typedefs.types;
import core.typedefs.color;
import gui.objects.camera;
import gui.formats.tga;
import gui.objects.object3d;

class HeightMap : Surface{

  this(double x, double y, double z, Texture texture){
    this(x, y, z, texture.width, texture.height);
    this.map         = heightFromAlpha!float(texture);
    this.colormap    = asColorMap(texture);
    highlight_color  = new Color(1.0,0.0,0.0);
  }

  this(double x, double y, double z, int sx, int sy){
    super(x, y, z, sx, sy);
    this.map         = newmatrix!float(sx,sy,0,true);
    this.colormap    = newclassmatrix!Color(sx,sy);
    highlight_color  = new Color(1.0,0.0,0.0);
  }
  
  float getHeight(int x, int y){ return map[x][y]; }
  
  Color getColor(int x, int y){ 
    if(highlight[0] == x && highlight[1] == y){
        return highlight_color;
    }else{
      return colormap[x][y];
    }
  }
  
  void setHighlight(int x, int y){
    if(x >= 0 && x < getMapX()) highlight[0]=x;
    if(y >= 0 && y < getMapY()) highlight[1]=y;
    buffer();
  }
  
  float[][]  map;
  Color[][]  colormap;
  Color      highlight_color;
  int[2]     highlight = [0,0];
}

class Surface : Object3D{

  this(double x, double y, double z, int sx, int sy){
    super(x,y,z);
    size[0] = sx;
    size[1] = sy;
  }
  
  void buffer(){ 
    if(displaylist)glDeleteLists(displaylist,1);
    displaylist = glGenLists(1);
    glNewList(displaylist, GL_COMPILE);
    printOGL(getFaceType());
    glEndList();
    writefln("[OBJ] Surface buffered in %s",displaylist);
    buffered(true);
  }
  
  abstract float  getHeight(int x, int y);
  abstract Color  getColor(int x, int y);

  void render(int faceType = GL_TRIANGLE_STRIP){
    glToLocation();
    if(buffered){
      glCallList(displaylist);
    }else{
      printOGL(faceType);
    }
    glPopMatrix();
  }

  void printOGL(int faceType = GL_TRIANGLE_STRIP){
    Color color;
    for(int i = 0; i < (size[0]-1); i++) {
      glBegin(faceType);
      for(int j = 0; j < size[1]; j++) {
        color = getColor(i,j);
        glColor4f(color.r(), color.g(), color.b(), color.alpha());
        glVertex3f(i*sx(), getHeight(i, j), j*sz());
        color = getColor(i+1,j);
        glColor4f(color.r(), color.g(), color.b(), color.alpha());
        glVertex3f((i+1)*sx(), getHeight(i+1, j), j*sz());
      }
      glEnd();
    }
  }
  
  int getMapX(){ return size[0]; }
  int getMapY(){ return size[1]; }
  int getFaceType(){ return GL_TRIANGLE_STRIP; }
  
  private:
    int[2] size;
    GLint  displaylist;
}
