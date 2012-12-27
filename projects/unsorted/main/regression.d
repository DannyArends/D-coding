/******************************************************************//**
 * \file src/main/regression.d
 * \brief Main function for rake app::regression
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio, std.math, core.terminal, core.arrays.types;
import plugins.regression.regression;

void main(string[] args){
  MSG("Multiple linear regression in D\n");
  double[][] designmatrix = [[1,1],[1,1],[1,2],[1,2],[1,2],[1,2]];
  double[]   trait = [4,1,3,7,5,6];
  double[]   weight = [1,1,1,1,1,1];
  int[]      nullmodellayout = [1,1];  //The D[][1] is dropped from the model to test its predictive value 
  for(size_t i = 0; i < designmatrix.length; i++){
    MSG("[%s] = %s",trait[i],designmatrix[i]);
  }
  writeln();
  MSG("LOD = %s",multipleregression(designmatrix,trait,weight,nullmodellayout,0));
}
