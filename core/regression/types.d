/**
 * \file types.D
 *
 * Copyright (c) 2010 Danny Arends
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module core.regression.types;

import std.stdio;
import std.conv;
import core.memory;

alias double[][] dmatrix;
alias bool[][] bmatrix;
alias char[][] cmatrix;
alias int[][] imatrix;

alias double[] dvector;
alias char[] cvector;
alias int[] ivector;

T[][] newmatrix(T)(uint nrow,uint ncol){
  T[][] x;
  x.length=nrow;
  for(uint i=0;i<nrow;i++){
    x[i].length=ncol;
    for(uint j=0;j<ncol;j++){
      x[i][j]= (*new T());
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

T[] newvector(T)(uint length){
  T[] x;
  x.length = length;
  for(int j=0;j<length;j++){
    x[j]=0;
  }
  return x;
}
