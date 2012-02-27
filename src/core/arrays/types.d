/******************************************************************//**
 * \file src/core/arrays/types.d
 * \brief Array type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.types;

import core.memory;
import std.random;

alias double[][] dmatrix;
alias bool[][] bmatrix;
alias char[][] cmatrix;
alias int[][] imatrix;

alias double[] dvector;
alias char[] cvector;
alias int[] ivector;

void freevector(T)(T[] v) {
  auto c = new GC();
  c.removeRange(cast(void*)v);
  c.free(cast(void*)v);
  v = null;
}

T[][] newmatrix(T)(uint nrow, uint ncol, T init = cast(T)0, bool rf = false){
  T[][] x;
  x.length=nrow;
  for(uint i=0;i<nrow;i++){
    x[i].length=ncol;
    for(uint j=0;j<ncol;j++){      
      if(rf){
        x[i][j] = cast(T)uniform(-3,3); //TODO: Remove this HACKY bit
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

T[] copyvector(T)(T[] c){
  T[] x;
  x.length = c.length;
  for(int j=0;j<c.length;j++){
    x[j]=c[j];
  }
  return x;
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

pure T[] newvector(T)(uint length, T value = cast(T)0){
  T[] x;
  for(int j=0;j<length;j++){
    x ~= value;
  }
  return x;
}
