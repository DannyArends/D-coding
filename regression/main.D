/**
 * \file main.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;

import types;
import regression

void main(string[] args){
  writefln("Multiple linear regression in D");
  dmatrix designmatrix = [[1,0],[1,1],[1,2],[1,0],[1,0]];
  dvector trait = [3.5,3.9,3.2,3.45,4.8];
  dvector weight = [1,1,1,1,1];
  ivector nullmodellayout = [1,1,1];
  writefln("LOD = ",multipleregression(designmatrix,trait,weight,nullmodellayout,0));
}