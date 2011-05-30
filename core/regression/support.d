/**
 * \file support.D
 * \brief Code file, Implementation of: \ref LUdecomposition, \ref LUsolve, \ref LUinvert
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
module core.regression.support;

import std.stdio;
import std.math;

import core.regression.types;
import core.regression.LUdecomposition;
//import r.r;

double Lnormal(double residual, double variance){
  return exp(-pow(residual/sqrt(variance),2.0)/2.0 - log(sqrt(2.0*PI*variance)));
  //return dnorm(residual,0,sqrt(variance),0);
}

dvector calculateparameters(uint nvariables, uint nsamples, dmatrix xt, dvector w, dvector y, int verbose){
  int d=0;
  double xtwj;
  dmatrix XtWX = newdmatrix(nvariables, nvariables);
  dvector XtWY = newdvector(nvariables);
  ivector indx = newivector(nvariables);
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
  double[][] Xt = newdmatrix(nvariables,nsamples);
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
  dvector indL = newdvector(nsamples);

  for (uint i=0; i<nsamples; i++){
    (*Fy)[i]  = Lnormal(residual[i],variance);
    indL[i]  += w[i] * (*Fy)[i];
    logL     += log(indL[i]);
  }
  
  return logL;
}

double betacf(double a, double b, double x){
  double qap,qam,qab,em,tem,d,bz,bm=1.0,bp,bpp,az=1.0,am=1.0,ap,app,aold;
  int m;
  qab=a+b;
  qap=a+1.0;
  qam=a-1.0;
  bz=1.0-qab*x/qap;
  for (m=1; m<=100; m++){
    em=m;
    tem=em+em;
    d=em*(b-em)*x/((qam+tem)*(a+tem));
    ap=az+d*am;
    bp=bz+d*bm;
    d= -(a+em)*(qab+em)*x/((qap+tem)*(a+tem));
    app=ap+d*az;
    bpp=bp+d*bz;
    aold=az;
    am=ap/bpp;
    bm=bp/bpp;
    az=app/bpp;
    bz=1.0;
    if ( fabs((az-aold)/az)  < 3.0e-7) return az;
  }
  writefln("a or b too big or max number of iterations too small");
  return 0;
}

/* functions gammln, betacf, betai necessary to calculate F(P,df1,df2) */
double gammln(double xx){
  double x,tmp,ser;
  dvector cof = [76.18009173, -86.50532033, 24.01409822, -1.231739516, 0.120858003e-2, -0.536382e-5];
  if (xx<1) writefln("warning: full accuracy only for xx>1; xx= ", xx);
  x=xx-1.0;
  tmp=x+5.5;
  tmp-= (x+0.5)*log(tmp);
  ser=1.0;
  for (int j=0; j<=5; j++) { 
    x+=1.0; 
    ser += cof[j]/x; 
  }
  return -tmp+log(2.50662827465*ser);
}

double betai(double a, double b, double x){
  double bt;
  if (x<0.0 || x>1.0){ 
    writefln("ERROR: x not between 0 and 1, x=",x); 
  }
  if(x==0.0 || x==1.0){
    bt=0.0;
  }else{
    bt=exp(gammln(a+b)-gammln(a)-gammln(b)+a*log(x)+b*log(1.0-x));
  }
  if(x<(a+1.0)/(a+b+2.0)){
    return bt*betacf(a,b,x)/a;
  }else{
    return 1.0-bt*betacf(b,a,1.0-x)/b;
  }
}

double inverseF(int df1, int df2, double alfa){
  double prob=0.0, minF=0.0, maxF=100.0, halfway=50.0, absdiff=1.0;
  int count=0;
  while ((absdiff>0.001)&&(count<100)){
    count++;
    halfway= (maxF+minF)/2.0;
    prob= betai(df2/2.0,df1/2.0,df2/(df2+df1*halfway));
    if(prob<alfa){
      maxF= halfway;
    }else{
      minF= halfway;
    }
    absdiff = fabs(prob-alfa);
  }
  return halfway;
}
