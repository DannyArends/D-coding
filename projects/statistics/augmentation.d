/******************************************************************//**
 * \file statistics/augmentation.d
 * \brief Missing data augmentation routine
 *
 * <i>Copyright (c) 1991-2012</i>Ritsert C. Jansen, Danny Arends, Pjotr Prins, Karl W. Broman<br>
 * Last modified May, 2012<br>
 * First written 1991<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module statistics.augmentation;
 
import std.stdio, std.math;
import core.arrays.types, plugins.regression.support;

const int RFUNKNOWN = 999;

enum : char{
  MLEFT = 'L',
  MMIDDLE='M',
  MRIGHT='R',
  MUNLINKED='U',
}

double rf(double cmdistance){ return (0.5*(1.0-exp(-0.02*cmdistance))); }

double[] calcrf(char[] position, double[] mapdistance){
  size_t nmarkers = position.length;
  double[] r = newvector!double(nmarkers, 0.0);
  for(size_t m=0; m<nmarkers; m++) {
    r[m]= RFUNKNOWN;
    if((position[m]==MLEFT) || (position[m]==MMIDDLE)){
      r[m]= rf(mapdistance[m+1]-mapdistance[m]);
      if(r[m]<0){
        writefln("[CALC_RF] ERROR: Position=",position[m]," r[m]=",r[m]);
        return r;
      }
    }
  }
  return r;
}

char[] markerpos(int[] chr){
  size_t nmarkers = chr.length;
  char[] position = newvector!char(nmarkers,MUNLINKED);
  for(size_t m = 0; m < nmarkers; m++){
    if(m==0){
      if(chr[m]==chr[m+1]){
        position[m]=MLEFT;
      }else{
        position[m]=MUNLINKED;
      }
    }else if(m==nmarkers-1){
      if(chr[m]==chr[m-1]){ 
        position[m]=MRIGHT;
      }else{
        position[m]=MUNLINKED;
      }
    }else if(chr[m]==chr[m-1]){
      if(chr[m]==chr[m+1]){
        position[m]=MMIDDLE;
      }else{
        position[m]=MRIGHT;
      }
    }else{
      if(chr[m]==chr[m+1]){
        position[m]=MLEFT;
      }else{
        position[m]=MUNLINKED;
      }
    }
  }
  return position;
}

double augmentation(double[][] markers, char[] positions, double[] rf, int verbose){
  for(size_t i = 0; i < markers.length; i++){ }
  return 0.0;
}
