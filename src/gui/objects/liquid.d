module gui.objects.liquid;

import std.stdio;
import std.conv;
import std.math;
import std.random;

import gl.gl_1_0;
import gl.gl_1_1;

import core.typedefs.types;
import core.typedefs.color;
import gui.formats.tga;
import gui.objects.surface;

class Liquid : HeightMap{

  this(double x, double y, double z, Texture texture){
    super(x, y, z, texture);
    liquid[0]   = newmatrix!float(texture.width,texture.height);
    liquid[1]   = newmatrix!float(texture.width,texture.height);
    dampmap     = dampFromAlpha(texture);
  }

  this(double x, double y, double z, int sx, int sy){
    super(x, y, z, sx, sy);
    liquid[0]   = newmatrix!float(sx,sy);
    liquid[1]   = newmatrix!float(sx,sy);
    dampmap     = newmatrix!bool(sx,sy,true);
  }
  
  float calcN(int x, int y, float x1, float x2, float y1, float y2 = 0.0){
    if(!dampmap) return 0.0;
    float n = (x1 + x2 + y1 + y2) / 2.0;
    n -= liquid[f][x][y];
    n = n - (n / 20.0);
    return n;
  }

  void update(){
    int x, y;
    float n;
    for(x = 1; x < getMapX()-1; x++) {
      for(y = 1; y < getMapY()-1; y++) {
        liquid[f][x][y] = calcN(x, y,liquid[t][x-1][y],liquid[t][x+1][y],liquid[t][x][y-1],liquid[t][x][y+1]);
      }
    }

    y = 0;
    for(x = 1; x < getMapX()-1; x++) {
        liquid[f][x][y] = calcN(x,y,liquid[t][x-1][y],liquid[t][x+1][y],liquid[t][x][y+1]);
    }
    x = 0;
    for(y = 1; y < getMapY()-1; y++) {
        liquid[f][x][y] = calcN(x,y,liquid[t][x+1][y],liquid[t][x][y-1],liquid[t][x][y+1]);
    }
    x = getMapX()-1;
    for(y = 1; y < getMapY()-1; y++) {
        liquid[f][x][y] = calcN(x,y,liquid[t][x-1][y],liquid[t][x][y-1],liquid[t][x][y+1]);
    }
    y = getMapY()-1;
    for(x = 1; x < getMapX()-1; x++) {
      liquid[f][x][y] = calcN(x,y,liquid[t][x-1][y],liquid[t][x+1][y],liquid[t][x][y-1]);
    }
    int tmp = t; t = f; f = tmp;
  }

  float getHeight(int x, int y){
    float sm = super.getHeight(x,y);
    if(dampmap[x][y]){
      return sm;
    }
    return sm+liquid[t][x][y];    
  }
  
  Color getColor(int x, int y){
    Color c = super.getColor(x,y);
    if(dampmap[x][y]) return c;
    c.updateColor(2,liquid[t][x][y]+0.6);
    return c;
  }
  
  void effect(int x, int y, float effect = 10){
    if(x > 0 && x < getMapX()){
      if(y > 0 && y < getMapY()){
        liquid[f][x][y] -= effect;
      }
    }
  }

  int t         = 0;
  int f         = 1;
  float[][]  liquid[3];
  bool[][]   dampmap;
}
