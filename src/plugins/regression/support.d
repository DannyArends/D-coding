/**
 * \file support.d
 * \brief Code file, Implementation of: \ref Lnormal, \ref calculateparameters, \ref translatematrix, 
 * \ref calculatestatistics, \ref calculateloglikelihood and \ref inverseF.
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
module plugins.regression.support;

import std.stdio;
import std.math;

import core.typedefs.types;
import plugins.regression.LUdecomposition;
import r.r;

double Lnormal(double residual, double variance){
  //return exp(-pow(residual/sqrt(variance),2.0)/2.0 - log(sqrt(2.0*PI*variance)));
  return dnorm(residual,0,sqrt(variance),0);
}

dvector calculateparameters(uint nvariables, uint nsamples, dmatrix xt, dvector w, dvector y, int verbose){
  int d=0;
  double xtwj;
  dmatrix XtWX = newmatrix!double(nvariables, nvariables);
  dvector XtWY = newvector!double(nvariables);
  ivector indx = newvector!int(nvariables);
  if(verbose > 2) writefln("Calculating XtWX and XtWY");
  for(uint i=0; i<nsamples; i++){
    for(uint j=0; j<nvariables; j++){
      xtwj     = xt[j][i] * w[i];
      XtWY[j] += xtwj    * y[i];
      for(uint jj=0; jj<=j; jj++){
        XtWX[j][jj] += xtwj * xt[jj][i];
      }
    }
  }
  if(verbose > 2) writefln("XtWX: ",XtWX);
  LUdecompose(XtWX, nvariables, indx, &d);
  LUsolve(XtWX, nvariables, indx, XtWY);
  
  return XtWY;
}

dmatrix translatematrix(int nvariables, int nsamples, dmatrix x, int verbose){
  double[][] Xt = newmatrix!double(nvariables,nsamples);
  if(verbose > 2) writefln("Calculating Xt");
  for(uint i=0; i<nsamples; i++){
    for(uint j=0; j<nvariables; j++){
      Xt[j][i] = x[i][j];
    }
  }
  return Xt;
}

double calculatestatistics(uint nvariables, uint nsamples, dmatrix xt, dvector xtwy, dvector y, dvector w, dvector* fit, dvector* residual,int verbose){
  double variance = 0.0;
  for (uint i=0; i<nsamples; i++){
    (*fit)[i]      = 0.0;
    (*residual)[i] = 0.0;
    for (uint j=0; j<nvariables; j++){
      (*fit)[i]     += xt[j][i] * xtwy[j];
    }
    (*residual)[i]   = y[i]-(*fit)[i];
    variance        += w[i]*pow((*residual)[i],2.0);
  }
  variance /= nsamples;
  return variance;
}

double calculateloglikelihood(uint nsamples, dvector residual,dvector w, double variance, dvector* Fy,int verbose){
  double logL  = 0.0;
  dvector indL = newvector!double(nsamples);

  for (uint i=0; i<nsamples; i++){
    (*Fy)[i]  = Lnormal(residual[i],variance);
    indL[i]  += w[i] * (*Fy)[i];
    logL     += log(indL[i]);
  }
  
  return logL;
}

double inverseF(int df1, int df2, double alfa){
  return qf(1-alfa,df1,df2,0,0);
}
