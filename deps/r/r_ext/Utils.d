/* Converted to D from Utils.h by htod */
module r.r_ext.Utils;
/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1998-2005    Robert Gentleman, Ross Ihaka
 *                             and the R Development Core Team
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation; either version 2.1 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, a copy is available at
 *  http://www.r-project.org/Licenses/
 *
 *
 * Generally useful  UTILITIES  *NOT* relying on R internals (from Defn.h)
 */

import r.r_ext.Boolean;
import r.r_ext.Complex;

alias Rf_revsort revsort;
alias Rf_iPsort iPsort;
alias Rf_rPsort rPsort;
alias Rf_cPsort cPsort;
alias Rf_IndexWidth IndexWidth;
alias Rf_setIVector setIVector;
alias Rf_setRVector setRVector;
alias Rf_StringFalse StringFalse;
alias Rf_StringTrue StringTrue;
alias Rf_isBlankString isBlankString;
alias Rf_hsv2rgb hsv2rgb;

alias Rf_rgb2hsv rgb2hsv;

extern (C):
void  R_isort(int *, int );
void  R_rsort(double *, int );
void  R_csort(Rcomplex *, int );
void  rsort_with_index(double *, int *, int );
void  Rf_revsort(double *, int *, int );
void  Rf_iPsort(int *, int , int );
void  Rf_rPsort(double *, int , int );
void  Rf_cPsort(Rcomplex *, int , int );

void  R_qsort(double *v, int i, int j);
void  R_qsort_I(double *v, int *I, int i, int j);
void  R_qsort_int(int *iv, int i, int j);
void  R_qsort_int_I(int *iv, int *I, int i, int j);

int  Rf_IndexWidth(int );
char * R_ExpandFileName(char *);
void  Rf_setIVector(int *, int , int );
void  Rf_setRVector(double *, int , double );
Rboolean  Rf_StringFalse(char *);
Rboolean  Rf_StringTrue(char *);
Rboolean  Rf_isBlankString(char *);

double  R_atof(char *str);
double  R_strtod(char *c, char **end);
char * R_tmpnam(char *prefix, char *tempdir);
void  Rf_hsv2rgb(double h, double s, double v, double *r, double *g, double *b);
void  Rf_rgb2hsv(double r, double g, double b, double *h, double *s, double *v);

void  R_CheckUserInterrupt();
void  R_CheckStack();

int  findInterval(double *xt, int n, double x, Rboolean rightmost_closed, Rboolean all_inside, int ilo, int *mflag);
void  find_interv_vec(double *xt, int *n, double *x, int *nx, int *rightmost_closed, int *all_inside, int *indx);
void  R_max_col(double *matrix, int *nr, int *nc, int *maxes, int *ties_meth);
