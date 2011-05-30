/* Converted to D from Random.h by htod */
module r.r_ext.Random;
/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1998-2009    Robert Gentleman, Ross Ihaka
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
 */
import r.r_ext.Boolean;

enum{
  WICHMANN_HILL,
  MARSAGLIA_MULTICARRY,
  SUPER_DUPER,
  MERSENNE_TWISTER,
  KNUTH_TAOCP,
  USER_UNIF,
  KNUTH_TAOCP2,
}
extern (C):
alias int RNGtype;

enum{
  BUGGY_KINDERMAN_RAMAGE,
  AHRENS_DIETER,
  BOX_MULLER,
  USER_NORM,
  INVERSION,
  KINDERMAN_RAMAGE,
}
alias int N01type;


void  GetRNGstate();
void  PutRNGstate();
double  unif_rand();
double  norm_rand();
double  exp_rand();


alias uint Int32;

double * user_unif_rand();
void  user_unif_init(Int32 );
int * user_unif_nseed();
int * user_unif_seedloc();
double * user_norm_rand();
void  FixupProb(double *, int , int , Rboolean );
