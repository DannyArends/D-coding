/**********************************************************************
 * \file src/core/typedefs/types.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.types;

import std.stdio;
import std.conv;
import std.string;
import std.random;
import core.memory;

alias double[][] dmatrix;
alias bool[][] bmatrix;
alias char[][] cmatrix;
alias int[][] imatrix;

alias double[] dvector;
alias char[] cvector;
alias int[] ivector;

T[] stringArrayToType(T)(string[] entities){
  T[] rowleveldata;
  for(auto e=0;e < entities.length; e++){
    rowleveldata ~= to!T(entities[e]);
  }
  return rowleveldata;
}

struct Bone{
  float   length;
  string  name;
  bool    rotates = false;
  float   ori[4];
  string  objectname;
  Bone[]  bones;
}

struct Figure{
  string name;
  Bone root;
}

struct FPS{
  int   cnt = 0;
  int   fps = 0;
}

enum FileStatus{ 
  NO_SUCH_FILE = -6, 
  FILE_OPEN = -5, 
  READING_FILE = -4, 
  INDEXED_COLOR = -3, 
  MEMORY = -2, 
  COMPRESSED_FILE = -1, 
  OK = 0
}

struct Texture{
  string       name;
  FileStatus   status;
  uint[]       id;
  uint         type;
  uint         width,height,bpp;
  ubyte[]      data;
}

T[] toType(T)(ubyte[] buffer){
  T[] returnbuffer;
  foreach(int i, byte b ; buffer){
    returnbuffer ~= to!T(b);
  }
  return returnbuffer;
}

T[][] newmatrix(T)(uint nrow,uint ncol, T init = cast(T)0, bool rf = false){
  T[][] x;
  x.length=nrow;
  for(uint i=0;i<nrow;i++){
    x[i].length=ncol;
    for(uint j=0;j<ncol;j++){      
      if(rf){
        x[i][j] = cast(T)uniform(-3,3); //TODO Remove this HACKY bit
      }else{
        x[i][j] = init;
      }
    }
  }
  return x;
}

T[][] newclassmatrix(T)(uint nrow,uint ncol){
  T[][] x;
  x.length=nrow;
  for(uint i=0;i<nrow;i++){
    x[i].length=ncol;
    for(uint j=0;j<ncol;j++){
      x[i][j]= new T();
    }
  }
  return x;
}

T[][] vectortomatrix(T)(uint nrow, uint ncol, T[] invector){
  int c,r;
  T[][] outmatrix;
  outmatrix.length=nrow;
  for(r=0; r<nrow; r++){
    outmatrix[r].length=ncol;
    for(c=0; c<ncol; c++){
      outmatrix[r][c] = invector[(c*nrow)+r];
    }
  }
  return outmatrix;
}

void freevector(T)(T[] v) {
  auto c = new GC();
  c.removeRange(cast(void*)v);
  c.free(cast(void*)v);
  v = null;
}
void freematrix(T)(T[][] m,uint rows) {
  auto c = new GC();
  for (uint i=0; i < rows; i++) {
    if(m[i].length > 0) freevector!T(m[i]);
  }
  if(m.length >0){
    c.removeRange(cast(void*)m);
    c.free(cast(void*)m);
  }
}

T[] copyvector(T)(T[] c){
  T[] x;
  x.length = c.length;
  for(int j=0;j<c.length;j++){
    x[j]=c[j];
  }
  return x;
}


/*
 * Transforms a character to its value when SHIFT is pressed
 * Based on US-101 keyboard
 */
char toShiftChar(char c){
  try{
    switch(to!int(to!string(c))){
      case 0:
        return ')';
      break;
      case 1:
        return '!';
      break;
      case 2:
        return '@';
      break;
      case 3:
        return '#';
      break;      
      case 4:
        return '$';
      break;
      case 5:
        return '%';
      break;
      case 6:
        return '^';
      break;
      case 7:
        return '&';
      break;
      case 8:
        return '*';
      break;
      case 9:
        return '(';
      break;
      default:
      break;
    }
    return to!char(toUpper(to!string(c)));
  }catch{
    return to!char(toUpper(to!string(c)));
  }
}


T[] newvector(T)(uint length){
  T[] x;
  x.length = length;
  for(int j=0;j<length;j++){
    x[j]=0;
  }
  return x;
}
