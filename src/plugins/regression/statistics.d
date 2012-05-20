/******************************************************************//**
 * \file src/plugins/regression/statistics.d
 * \brief Basic statistical functions
 *
 * <i>Copyright (c) 1991-2012</i>Ritsert C. Jansen, Danny Arends, Pjotr Prins, Karl W. Broman<br>
 * Last modified May, 2012<br>
 * First written 1991<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.regression.statistics;
 
import std.math; 
import std.stdio;
import std.conv;

import core.arrays.search;

pure T doMean(T)(T[] data){
  T mean = 0;
  for(size_t i = 0; i < (data.length-1); i++){
    mean += (data[i] - mean) / (i + 1);
  }
  return mean;
}

pure T doSum(T)(T[] values ...){
  T s = 0;
  foreach(T x; values){ s += x; }
  return s;
}

pure real doSumOfSquares(T)(T[] data){
  T mean = doMean(data);
  real sumofsquares = 0;
  for(size_t i = 0; i < (data.length-1); i++){
    sumofsquares += pow((data[i]-mean),2);
  }
  return sumofsquares;
}

pure real doVariance(T)(T[] data){ return (doSumOfSquares!T(data)/data.length); }

pure real doVariance(T)(real sumofsquares,uint n){ return (sumofsquares/n); }

pure real doStandardDeviation(T)(T[] data){ return sqrt(doVariance!T(data)); }

real correlation_v1(T)(T[] d1, T[] d2){
  if(d1.length!=d2.length) throw new Exception("Error: Should have same length "~ to!string(d1.length) ~ " !=" ~ to!string(d2.length));
  
  real sumofsquares = 0;
  T mean1 = doMean(d1);
  T mean2 = doMean(d2);

  for(size_t i = 0; i < (d1.length-1); i++){
    T delta1 = (d1[i] - mean1);
    T delta2 = (d2[i] - mean2);
    sumofsquares += (delta1 * delta2);
  }
  real variance = doVariance!real(sumofsquares,cast(uint)d1.length);
  return (variance / (doStandardDeviation(d1)*doStandardDeviation(d2)));
}

double correlation_v2(T)(T[] x, T[] y){
  assert(x.length == y.length);
  double XiYi = 0;
  double Xi = 0;
  double Yi = 0;
  double XiP2 = 0;
  double YiP2 = 0;
  for(size_t i = 0; i < x.length; i++){
    XiYi += x[i] * y[i];
    Xi += x[i]; 
    Yi += y[i];
    XiP2 += x[i] * x[i]; 
    YiP2 += y[i] * y[i];
  }
  double onedivn = 1.0/x.length;
  return (XiYi - (onedivn*Xi*Yi)) / (sqrt(XiP2 - onedivn * pow(Xi, 2)) * sqrt(YiP2 - onedivn * pow(Yi, 2)));
}
