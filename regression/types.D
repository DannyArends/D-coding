/**
 * \file types.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/
 
module types;

import std.stdio;

alias double[][] dmatrix;
alias double[] dvector;
alias int[] ivector;

dmatrix newdmatrix(uint nrow,uint ncol){
  dmatrix x;
  x.length=nrow;
  foreach(int i, double[] row;x){
    x[i].length=ncol;
    for(int j=0;j<ncol;j++){
      x[i][j]=0;
    }
  }
  return x;
}

dvector newdvector(dvector c){
  dvector x;
  x.length = c.length;
  for(int j=0;j<c.length;j++){
    x[j]=c[j];
  }
  return x;
}

dvector newdvector(uint length){
  dvector x;
  x.length = length;
  for(int j=0;j<length;j++){
    x[j]=0;
  }
  return x;
}

ivector newivector(uint length){
  ivector x;
  x.length = length;
  for(int j=0;j<length;j++){
    x[j]=0;
  }
  return x;
}
