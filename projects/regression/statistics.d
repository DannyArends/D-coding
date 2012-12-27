/******************************************************************//**
 * \file src/plugins/regression/statistics.d
 * \brief Basic statistical functions
 *
 * <i>Copyright (c) 1991-2012</i>Ritsert C. Jansen, Danny Arends, Pjotr Prins, Karl W. Broman<br>
 * Last modified May, 2012<br>
 * First written 1991<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module regression.statistics;
 
import std.math, std.stdio, std.conv;
import dcode.arrays.algebra, dcode.arrays.search;

pure real doSumOfSquares(T)(T[] data){
  T mean = mean(data);
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
  assert(d1.length == d2.length, "Error: Should have same length");
  
  real sumofsquares = 0;
  T mean1 = mean(d1);
  T mean2 = mean(d2);

  for(size_t i = 0; i < (d1.length-1); i++){
    T delta1 = (d1[i] - mean1);
    T delta2 = (d2[i] - mean2);
    sumofsquares += (delta1 * delta2);
  }
  real variance = doVariance!real(sumofsquares, d1.length);
  return (variance / (doStandardDeviation(d1) * doStandardDeviation(d2)));
}

double correlation_v2(T)(T[] x, T[] y){
  assert(x.length == y.length, "Error: Should have same length");
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
