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

alias double[][] dmatrix;
alias double[] dvector;
alias char[] cvector;
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

cvector newcvector(uint length){
  cvector x;
  x.length = length;
  for(int j=0;j<length;j++){
    x[j]='-';
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
