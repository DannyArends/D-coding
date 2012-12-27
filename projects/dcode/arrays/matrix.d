/******************************************************************//**
 * \file src/core/arrays/matrix.d
 * \brief Fasta file type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.arrays.matrix;

import std.stdio, std.conv, std.math;
import dcode.arrays.vector;

pure T[][] newmatrix(T)(size_t nrow, size_t ncol, T init = T.init){
  T[][] x;
  x.length=nrow;
  for(size_t i=0;i < nrow;i++){
    x[i] = newvector!T(ncol,init);
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

T[][] randommatrix(T)(size_t nrow, size_t ncol){
  T[][] x = newmatrix!T(nrow,ncol);
  for(size_t i=0;i<nrow;i++){
    for(size_t j=0;j<ncol;j++){      
        x[i][j] = to!T(uniform(-4,4));
    }
  }
  return x;
}

pure T[][] absmatrix(T)(in T[][] i){
  T[][] m = newmatrix!T(i.length,i[0].length);
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m[r][c] = abs(i[r][c]);
    }
  }
  return m;
}

pure T[] unlist(T)(in T[][] i){
  T[] m;
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m ~= i[r][c];
    }
  }
  return m;
}

pure T[][] asmatrix(T)(in T[] i){
  T[][] m; T[] row;
  for(size_t idx = 0; idx < i.length; idx++){ row ~= i[idx]; }
  m ~= row;
  return m;
}

pure T[][] vectortomatrix(T)(size_t nrow, size_t ncol, in T[] invector){
  T[][] outmatrix = newmatrix!T(nrow, ncol);
  for(size_t r=0; r<nrow; r++){
    for(size_t c=0; c<ncol; c++){
      outmatrix[r][c] = invector[(c*nrow)+r];
    }
  }
  return outmatrix;
}


pure T[][] translate(T)(in T[][] i){
  if(i.length == 0) throw new Exception("Matrix needs to be at least of dim 1,1");
  T[][] m = newmatrix!T(i[0].length, i.length);
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m[c][r] = i[r][c];
    }
  }
  return m;
}

void printmatrix(T)(in T[][] m) {
  for(size_t r=0; r<m.length; r++) {
    for(size_t c=0; c<m[r].length; c++) {
      write(to!string(m[r][c])," ");
    }
    writeln();
  }
}

