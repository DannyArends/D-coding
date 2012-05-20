/******************************************************************//**
 * \file src/main/regression.d
 * \brief Main function for rake app::regression
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.math;

import r.r;
import r.lapack;

import core.arrays.types;
import plugins.regression.support;
import plugins.regression.regression;
import plugins.regression.augmentation;

void main(string[] args){
  writefln("Multiple linear regression in D");
  double[][] designmatrix = [[1,1],[1,1],[1,2],[1,2],[1,2],[1,2]];
  double[]   trait = [1,1,1,2000,2000,2000];
  double[]   weight = [1,1,1,1,1,1];
  int[]      nullmodellayout = [1,1];  //The D[][1] is dropped from the model to test its predictive value 
  for(size_t i = 0; i < designmatrix.length; i++){
    writefln("[%s] = %s",trait[i],designmatrix[i]);
  }
  writefln("LOD = %s",multipleregression(designmatrix,trait,weight,nullmodellayout,0));
}
