/**********************************************************************
 * \file src/plugins/regression/regression.d
 *
 * copyright (c) 1991-2010 Ritsert C Jansen, Danny Arends, Pjotr Prins, Karl Broman
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.regression.regression;
 
import std.stdio;
import std.conv;
import std.math;

import core.arrays.types;
import plugins.regression.support;

void multipleregression_R(int* nvariables,int* nsamples, double* x, double* w, double* y,double* estparams, int* nullmodellayout,int* verbose, double* lodscore){
  dvector xx = x[0..(*nvariables)*(*nsamples)];
  dvector ww = w[0..(*nsamples)];
  dvector yy = y[0..(*nsamples)];
  ivector nullmodel = nullmodellayout[0..(*nvariables)];
  
  dmatrix designmatrix = vectortomatrix!double((*nsamples),(*nvariables),xx);
  
  (*lodscore)  = multipleregression(designmatrix, yy, ww, nullmodel,(*verbose));
  
  dmatrix Xt   = translatematrix((*nvariables),(*nsamples),designmatrix,(*verbose));
  dvector XtWY = calculateparameters((*nvariables),(*nsamples),Xt,ww,yy,(*verbose));
  for (uint i=0; i < cast(uint)(*nvariables); i++){
    estparams[i] = XtWY[i];    
  }
  freematrix(Xt,(*nvariables));
  freevector(XtWY);
  if((*verbose)) writefln("lodscore: %f\n",(*lodscore));
}

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
    dvector wcopy = copyvector!double(weight);
    return (2*likelihoodbyem(cast(uint)designmatrix[0].length,cast(uint) designmatrix.length, designmatrix, wcopy, y, verbose) - 
            2*nullmodel(cast(uint)designmatrix[0].length,cast(uint) designmatrix.length, designmatrix, wcopy, y, nullmodellayout, verbose)) / 4.60517;
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
  
  dvector Fy = newvector!double(nsamples);
  ivector nullmodellayout = newvector!int(nvariables);
  
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
  dvector Fy = newvector!double(nsamples);
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

  dvector fit = newvector!double(nsamples);
  dvector residual = newvector!double(nsamples);
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
