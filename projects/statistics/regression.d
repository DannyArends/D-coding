/******************************************************************//**
 * \file src/plugins/regression/regression.d
 * \brief Basic weighted multiple regression by ML or ReML
 *
 * <i>Copyright (c) 1991-2012</i>Ritsert C. Jansen, Danny Arends, Pjotr Prins, Karl W. Broman<br>
 * Last modified May, 2012<br>
 * First written 1991<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module statistics.regression;
 
import std.stdio, std.math;
import std.string : format;

import dcode.errors, dcode.arrays.vector;
import dcode.arrays.matrix : translate;

import statistics.support;

Model[2] mregression(in double[][] dm, in double[] y, double[] w, in int[] nullmodel = [1], bool verbose = false){
  if(dm.length != w.length) abort(format("No weights for individuals found", dm.length, w.length));
  if(dm.length != y.length) abort("No y variable for some individuals found"); 
  
  if(!sumvector!double(dm[0]) == y.length) writefln("NOTE: No estimate of constant in model");

  Model model  = likelihoodbyem(dm, w, y, verbose);
  Model nmodel = mfregression(dm, w, y, nullmodel, verbose);
  return [model, nmodel];
}

Model likelihoodbyem(in double[][] x, double[] w, in double[] y, bool verbose = false){
  uint   nvariables = cast(uint)x[0].length;
  uint   nsamples   = cast(uint)x.length;
  uint   maxemcycles = 1000;
  uint   emcycle     = 0;
  double delta       = 1.0f;
  double logL        = 0.0f;
  double logLprev    = 0.0f;
  
  Model f;
  if(verbose) writefln("Starting EM:");
  while((emcycle<maxemcycles) && (delta > 1.0e-10)){
    f = mfregression(x, w, y);

    for(size_t s = 0; s < nsamples; s++){
      if(w[s] != 0) w[s] = (w[s] + f.Fy[s])/w[s];
    }
    delta = fabs(f.logL - logLprev);
    logLprev=f.logL;
    emcycle++;
  }
  
  if(verbose) writefln("[REGRESSION] EM took %d/%d cyclies", emcycle, maxemcycles);
  return f;
}

Model mfregression(in double[][] x, in double[] w, in double[] y, in int[] nullmodel = [], bool verbose = false){
  size_t nvariables = x[0].length;
  size_t nsamples   = x.length;
  double[][] Xt  = translate!double(x);
  double[] XtWY  = calcparams(nvariables,nsamples,Xt, w, y);
  if(nullmodel.length != 0){
    for(size_t i = 1; i < nvariables; i++){
       // The nullmodel has always 1 parameter less Y = M + F1..Fn + Error
       // (The first parameter is the estimated mean)
      if(nullmodel[(i-1)] == 1) XtWY[i] = 0.0;
    }
  }
  Stats s  = calcstats(nvariables, nsamples, Xt, XtWY, y, w);
  Model f = calcloglik(nsamples, s.residual, w, s.variance, verbose);
  f.params = copyvector(XtWY);
  f.stats  = s;
  return f;
}

