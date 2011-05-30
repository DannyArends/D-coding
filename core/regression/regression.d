/**
 * \file regression.D
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
 
module core.regression.regression;
 
import std.stdio;
import std.math;

import core.regression.types;
import core.regression.support;

double multipleregression(dmatrix designmatrix, dvector y, dvector weight, ivector nullmodellayout,int verbose){
    if (designmatrix.length != weight.length) {
      writefln("No weights for some individuals found");
      return 0;
    }
    if (designmatrix.length != y.length) {
      writefln("No y variable for some individuals found");
      return 0;
    }
    double sum=0;
    foreach(int i,double d; designmatrix[0]){
      sum+=d;
    }
    if (!sum == y.length) {
      writefln("No estimate of constant in model");
    }
    dvector estparams;
    dvector wcopy = newdvector(weight);
    return (2*likelihoodbyem(designmatrix[0].length, designmatrix.length, designmatrix, wcopy, y, verbose) - 2 * nullmodel(designmatrix[0].length, designmatrix.length, designmatrix, wcopy, y, nullmodellayout, verbose)) / 4.60517;
}

double likelihoodbyem(uint nvariables,uint nsamples, dmatrix x, dvector w, dvector y,int verbose){
  uint   maxemcycles = 1000;
  uint   emcycle     = 0;
  double delta       = 1.0f;
  double logL        = 0.0f;
  double logLprev    = 0.0f;
  
  if(verbose){
    writefln("Designmatrix: %s",x);
  }
  
  dvector Fy = newdvector(nsamples);
  ivector nullmodellayout = newivector(nvariables);
  
  if(verbose > 1) writefln("Starting EM:");
  while((emcycle<maxemcycles) && (delta > 1.0e-9)){
    logL = multivariateregression(nvariables,nsamples,x,w,y,Fy,false,nullmodellayout,verbose);
    for(uint s=0;s<nsamples;s++){
      if(w[s] != 0) w[s] = (w[s] + Fy[s])/w[s];
    }
    delta = fabs(logL-logLprev);
    logLprev=logL;
    emcycle++;
  }
  
  writefln("EM took %d/%d cyclies", emcycle, maxemcycles);
  multivariateregression(nvariables,nsamples,x,w,y,Fy,false,nullmodellayout,2);
  return (logL);
}

double nullmodel(uint nvariables, uint nsamples, dmatrix x, dvector w, dvector y,ivector nullmodellayout,int verbose){
  dvector Fy = newdvector(nsamples);
  return multivariateregression(nvariables,nsamples,x,w,y,Fy,true,nullmodellayout,verbose);;
}

double multivariateregression(uint nvariables, uint nsamples, dmatrix x, dvector w, dvector y, dvector Fy, bool nullmodel, ivector nullmodellayout,int verbose){
  dmatrix Xt   = translatematrix(nvariables,nsamples,x,verbose);
  dvector XtWY = calculateparameters(nvariables,nsamples,Xt,w,y,verbose);

  if(nullmodel){
    for (uint i=1; i < nvariables; i++){
      if(nullmodellayout[(i-1)] == 1){ //SHIFTED Because the nullmodel has always 1 parameter less (The first parameter estimated mean)
        XtWY[i] = 0.0;
      }
    }
  }

  dvector fit = newdvector(nsamples);
  dvector residual = newdvector(nsamples);
  double  variance  = calculatestatistics(nvariables, nsamples, Xt, XtWY, y, w, &fit, &residual,verbose);
  double  logLQTL   = calculateloglikelihood(nsamples, residual, w, variance, &Fy, verbose);
  
  if(verbose > 1){
    writefln("Variance: %f",variance);
    writefln("Weights: %f",w);
    writefln("Estimated parameters: %f",XtWY);
    writefln("Estimated fit: %f",fit);
    writefln("Estimated residuals: %f",residual);
    writefln("Loglikelihood: %f",logLQTL);
  }

  return logLQTL;
}
