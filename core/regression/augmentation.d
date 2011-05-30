/**
 * \file augmentation.D
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
 
module core.regression.augmentation;
 
import std.stdio;
import std.math;

private import core.regression.types;
private import core.regression.support;


double rf(double cmdistance){
  return (0.5*(1.0-exp(-0.02*cmdistance)));
}

const int RFUNKNOWN = 999;

enum : char{
  MLEFT = 'L',
  MMIDDLE='M',
  MRIGHT='R',
  MUNLINKED='U',
}

dvector calcrf(cvector position, dvector mapdistance){
  uint nmarkers = position.length;
  dvector r = newdvector(nmarkers);
  for(uint m=0; m<nmarkers; m++) {
    r[m]= RFUNKNOWN;
    if ((position[m]==MLEFT)||(position[m]==MMIDDLE)) {
      r[m]= rf(mapdistance[m+1]-mapdistance[m]);
      if (r[m]<0) {
        writefln("ERROR: Position=",position[m]," r[m]=",r[m]);
        return r;
      }
    }
  }
  return r;
}

cvector markerpos(ivector chr){
  uint nmarkers = chr.length;
  cvector position = newcvector(nmarkers);
  for(uint m=0; m<nmarkers; m++){
    if(m==0){
      if(chr[m]==chr[m+1]) 
        position[m]=MLEFT;
      else 
        position[m]=MUNLINKED;
    } else if (m==nmarkers-1) {
      if (chr[m]==chr[m-1]) 
        position[m]=MRIGHT;
      else 
        position[m]=MUNLINKED;
    } else if (chr[m]==chr[m-1]) {
      if (chr[m]==chr[m+1]) 
        position[m]=MMIDDLE;
      else 
        position[m]=MRIGHT;
    } else {
      if (chr[m]==chr[m+1]) 
        position[m]=MLEFT;
      else 
        position[m]=MUNLINKED;
    }
  }
  return position;
}

double augmentation(dmatrix markers, cvector positions, dvector rf, int verbose){
  for(uint i=1; i < markers.length; i++){
  
  }
  return 0.0;
}
