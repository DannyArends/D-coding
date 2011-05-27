/**
 * \file statistics.D
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
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
 * Contains: doMean, doStandardDeviation, doCorrelation
 * 
 **/
 
import std.math; 
import std.stdio;
import std.conv;

import textreader;
import arrayfunctions;

pure T doMean(T)(T[] data){
  T mean = 0;
  for(uint i = 0; i < (data.length-1); i++){
    mean += (data[i] - mean) / (i + 1);
  }
  return mean;
}

pure int doSum(T)(T[] values ...){
  T s = 0;

  foreach (int x; values){
    s += x;
  }
  return s;
}

pure real doStandardDeviation(T)(T[] data){
  T mean = doMean(data);
  real sumofsquares = 0;
  for(uint i = 0; i < (data.length-1); i++){
    sumofsquares += pow((data[i]-mean),2);
  }
  return sqrt(sumofsquares);
}

real doCorrelation(T)(T[] d1, T[] d2){
  if(d1.length!=d2.length){
    writefln("Error: Should have same length %d != %d", d1.length, d2.length);
    return 0;
  }
  
  real sumofsquares = 0;
  T mean1 = doMean(d1);
  T mean2 = doMean(d2);

  for(uint i = 0; i < (d1.length-1); i++){
    T delta1 = (d1[i] - mean1);
    T delta2 = (d2[i] - mean2);
    sumofsquares += (delta1 * delta2);
  }
  return (sumofsquares / (doStandardDeviation(d1)*doStandardDeviation(d2)));
}

void main(string[] args){
  auto dataset = new LargeFileScanner();
  
  uint individuals[] = doRange(19,100);
  auto data1 = dataset.loadSubMatrix!double(args[1],individuals);
  foreach(ref a; data1){
    foreach(ref b; data1){ 
      writef("%f\t", doCorrelation!double(a,b));
    }
    write("\n");
  }
}
