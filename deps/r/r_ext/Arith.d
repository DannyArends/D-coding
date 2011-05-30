/* Converted to D from Arith.h by htod */
module r.r_ext.Arith;
/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1995, 1996  Robert Gentleman and Ross Ihaka
 *  Copyright (C) 1998--2007  The R Development Core Team.
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
import std.c.math;

import r.r_ext.libextern;

extern (C):
  extern double R_NaN;
  extern double R_PosInf;
  extern double R_NegInf;
  extern double R_NaReal;
  extern int R_NaInt;
  alias R_NaInt NA_LOGICAL;
  alias R_NaInt NA_INTEGER;
  alias R_NaReal NA_REAL;
  int  R_IsNA(double );
  int  R_IsNaN(double );
  int  R_finite(double );
