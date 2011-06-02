/**
 * \file regression.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;

import r.r;

import core.regression.types;
import core.regression.support;
import core.regression.regression;
import core.regression.augmentation;

void main(string[] args){
  loadR();
  writefln("Multiple linear regression in D");
  dmatrix designmatrix = [[1,0],[1,1],[1,2],[1,0],[1,0]];
  dvector trait = [3.5,3.9,3.2,3.45,4.8];
  dvector weight = [1,1,1,1,1];
  ivector nullmodellayout = [1,1,1];
  writefln("LOD = %f",multipleregression(designmatrix,trait,weight,nullmodellayout,1));
}
