/**
 * \file augmentation.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/
 
module augmentation;
 
import std.stdio;
import std.math;

import types;
import support;


double rf(double cmdistance){
  return (0.5*(1.0-exp(-0.02*cmdistance)));
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
        return;
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
}
