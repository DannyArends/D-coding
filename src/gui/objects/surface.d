/******************************************************************//**
 * \file src/gui/objects/surface.d
 * \brief 3D surface definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
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
import core.typedefs.camera;
import gui.formats.tga;
import gui.objects.object3d;

/*! \brief 3D HeightMap
 *
 *  Representation of a 3D HeightMap
 */
class HeightMap : Surface{

  this(double x, double y, double z, float[][] map, Color[][] colors){
    super(x, y, z, map.length, map[0].length);
    this.map         = map;
    this.colormap    = colors;
    highlight_color  = new Color(1.0,0.0,0.0);
  }

  this(double x, double y, double z, Texture texture){
    super(x, y, z, texture.width, texture.height);
    this.map         = heightFromAlpha!float(texture);
    this.colormap    = asColorMap(texture);
    highlight_color  = new Color(1.0,0.0,0.0);
  }

  this(double x, double y, double z, int sx, int sy){
    super(x, y, z, sx, sy);
    this.map         = randommatrix!float(sx,sy);
    this.colormap    = newmatrix!Color(sx,sy, new Color());
    highlight_color  = new Color(1.0,0.0,0.0);
  }
  
  override float getHeight(int x, int y){ return map[x][y]; }
  
  override Color getColor(int x, int y){ 
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

/*! \brief 3D Surface
 *
 *  Representation of a 3D Surface
 */
class Surface : Object3D{

  this(double x, double y, double z, int sx, int sy){
    super(x,y,z);
    size[0] = sx;
    size[1] = sy;
  }
  
  override void buffer(){ 
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

  override void render(int faceType = GL_TRIANGLE_STRIP){
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
  override int getFaceType(){ return GL_TRIANGLE_STRIP; }
  
  private:
    int[2] size;
    GLint  displaylist;
}
