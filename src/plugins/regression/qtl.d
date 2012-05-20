/******************************************************************//**
 * \file src/plugins/regression/qtl.d
 * \brief Single marker QTL mapping in D 2.0
 *
 * <i>Copyright (c) 1991-2012</i>Ritsert C. Jansen, Danny Arends, Pjotr Prins, Karl W. Broman<br>
 * Last modified May, 2012<br>
 * First written 1991<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.regression.qtl;

import std.stdio;
import std.math;
import std.datetime;

import core.arrays.types;
import core.arrays.ranges;
import plugins.regression.support;
import plugins.regression.regression;

class SingleQTL{
  double[][] analyse(int[][] genotypes, double[][] phenotypes, int[] geno_cov = [], bool verbose = true){
    SysTime stime = Clock.currTime();
    double[][] lodmatrix = newmatrix!double(phenotypes.length, genotypes.length);
    if(verbose) write(" ");
    for(size_t p = 0; p < phenotypes.length; p++){
      for(size_t m = 0; m < genotypes.length; m++){
        double[] w = newvector!double(phenotypes[0].length,1.0);
        int[] nm = newvector!int(1,1);
        lodmatrix[p][m] = multipleregression(createdesignmatrix(genotypes, m, geno_cov), phenotypes[p], w, nm, false);
      }
      if(verbose) write(".");
      stdout.flush();
    }
    if(verbose) writeln("\n - Mapped QTL: ",(Clock.currTime()-stime).total!"msecs"() / 1000.0," seconds");
    return lodmatrix;
  }
}
double[][] createdesignmatrix(int[][] genotypes, int marker, int[] geno_cov = [], bool intercept = true){
  double[][] dm;
  dm.length = genotypes[0].length;
  size_t ncols = 1 + geno_cov.length + cast(int)intercept;
  for(size_t v=0; v < ncols; v++){
    for(size_t i=0; i < genotypes[0].length; i++){
      dm[i].length = 1 + geno_cov.length + cast(int)intercept;
      if(intercept && v==0){
        dm[i][v] = 1.0;
      }else{
        if(v==(dm[i].length-1)){
          dm[i][v] = cast(double) genotypes[marker][i];
        }else{
          uint cov = v - cast(uint) intercept;
          dm[i][v] = cast(double) genotypes[geno_cov[cov]][i];
        }
      }
    }
  }
  return dm;
}
