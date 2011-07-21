/**
 * \file regression.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;

import r.r;
import r.lapack;

import core.typedefs.types;
import plugins.regression.support;
import plugins.regression.regression;
import plugins.regression.augmentation;

void main(string[] args){
  writefln("Multiple linear regression in D");
  dmatrix designmatrix = [[1,1],[1,1],[1,2],[1,2],[1,2],[1,2]];
  dvector trait = [1,1,1,2000,2000,2000];
  dvector weight = [1,1,1,1,1,1];
  ivector nullmodellayout = [1,1];  //The D[][1] is dropped from the model to test its predictive value 
  for(uint i=0; i<designmatrix.length; i++){
    writefln("[%f] = %f",trait[i],designmatrix[i]);
  }
  writefln("LOD = %f",multipleregression(designmatrix,trait,weight,nullmodellayout,0));
}
