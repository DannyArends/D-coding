/******************************************************************//**
 * \file src/core/arrays/types.d
 * \brief Array type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.types;

import core.memory, std.random, std.conv;

alias double[][] dmatrix;
alias bool[][]   bmatrix;
alias char[][]   cmatrix;
alias int[][]    imatrix;

alias double[]   dvector;
alias char[]     cvector;
alias int[]      ivector;

void freevector(T)(ref T[] v) {
  GC.removeRange(cast(void*)v);
  GC.free(cast(void*)v);
}

T[][] randommatrix(T)(size_t nrow, size_t ncol){
  T[][] x = newmatrix!T(nrow,ncol);
  for(size_t i=0;i<nrow;i++){
    for(size_t j=0;j<ncol;j++){      
        x[i][j] = to!T(uniform(-4,4));
    }
  }
  return x;
}

pure T[][] newmatrix(T)(size_t nrow, size_t ncol, T init = T.init){
  T[][] x;
  x.length=nrow;
  for(size_t i=0;i < nrow;i++){
    x[i] = newvector!T(ncol,init);
  }
  return x;
}

pure T[] copyvector(T)(T[] c){
  T[] x;
  x.length = c.length;
  for(size_t j=0; j < c.length;j++){
    x[j]=c[j];
  }
  return x;
}

void freematrix(T)(T[][] m, size_t rows) {
  for(size_t i=0; i < m.length; i++) {
    if(m[i].length > 0) freevector!T(m[i]);
  }
  GC.removeRange(cast(void*)m);
  GC.free(cast(void*)m);
}

pure T[][] vectortomatrix(T)(size_t nrow, size_t ncol, T[] invector){
  T[][] outmatrix;
  outmatrix.length=nrow;
  for(size_t r=0; r<nrow; r++){
    outmatrix[r].length=ncol;
    for(size_t c=0; c<ncol; c++){
      outmatrix[r][c] = invector[(c*nrow)+r];
    }
  }
  return outmatrix;
}

pure T[] newvector(T)(size_t length, T value = T.init){
  T[] x;
  for(size_t j=0;j<length;j++){ x ~= value; }
  return x;
}
