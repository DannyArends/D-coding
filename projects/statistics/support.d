/******************************************************************//**
 * \file statistics/support.d
 * \brief Regression supporting functions
 *
 * <i>Copyright (c) 1991-2012</i>Ritsert C. Jansen, Danny Arends, Pjotr Prins, Karl W. Broman<br>
 * Last modified May, 2012<br>
 * First written 1991<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module statistics.support;

import std.stdio, std.math;
import dcode.arrays.vector, dcode.arrays.matrix;
import statistics.LUdecomposition;

immutable size_t NULL = 0;
immutable size_t MODEL = 1;

struct Stats{
  real     variance = 0.0;
  double[] fit;
  double[] residual;
}

struct Model{
  double   logL = 0.0;
  double[] Fy;
  double[] indL;
  double[] params;
  Stats    stats;
}

double Lnormal(double residual, double variance){
  return exp(-pow(residual/sqrt(variance),2.0)/2.0 - log(sqrt(2.0*acos(-1.0)*variance)));
}

double toLOD(Model model, Model nmodel){ return(abs((2.0 * model.logL) - (2.0 * nmodel.logL)) / 4.60517); }
double toLOD(Model[2] models){ return toLOD(models[MODEL], models[NULL]); }

Model calcloglik(uint nsamples, in double[] residual, in double[] w, real variance, bool verbose = true){
  Model f = Model(0.0, newvector!double(nsamples, 0.0), newvector!double(nsamples, 0.0));

  for(size_t i=0; i < nsamples; i++){
    f.Fy[i]  = Lnormal(residual[i], variance);
    f.indL[i]  += w[i] * f.Fy[i];
    f.logL   += log(f.indL[i]);
  }
  return f;
}

Stats calcstats(size_t nv, size_t ns, in double[][] xt, in double[] xtwy, in double[] y, in double[] w){
  Stats s = Stats(0.0, newvector!double(ns, 0.0), newvector!double(ns, 0.0));

  for(size_t i=0; i < ns; i++){
    s.fit[i]      = 0.0;
    s.residual[i] = 0.0;
    for(size_t j=0; j < nv; j++){
      s.fit[i]     += xt[j][i] * xtwy[j];
    }
    s.residual[i]   = y[i] - s.fit[i];
    s.variance     += w[i] * pow(s.residual[i], 2.0);
  }
  s.variance /= ns;
  return s;
}

double[] calcparams(size_t nv, size_t ns, in double[][] xt, in double[] w, in double[] y){
  int d=0;
  double xtwj;
  double[][] XtWX = newmatrix!double(nv, nv, 0.0);
  double[]   XtWY = newvector!double(nv, 0.0);
  int[]      indx = newvector!int(nv, 0);

  for(size_t i=0; i < ns; i++){
    for(size_t j=0; j < nv; j++){
      xtwj     = xt[j][i] * w[i];
      XtWY[j] += xtwj     * y[i];
      for(size_t jj=0; jj <= j; jj++){
        XtWX[j][jj] += xtwj * xt[jj][i];
      }
    }
  }
  LUdecompose(XtWX, nv, indx, &d);
  LUsolve(XtWX, nv, indx, XtWY);
  return XtWY;
}

