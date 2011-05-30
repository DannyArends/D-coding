/* Converted to D from Constants.h by htod */
module r.r_ext.Constants;
/*
 *  R : A Computer Language for Statistical Data Analysis
 *  Copyright (C) 1995, 1996  Robert Gentleman and Ross Ihaka
 *  Copyright (C) 1998-2007   The R Development Core Team.
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
 */

const M_PI = 3.141592653589793238462643383279502884197169399375;


alias M_PI PI;
import core.stdc.float_;
//C     #define SINGLE_EPS     FLT_EPSILON
//C     #define SINGLE_BASE    FLT_RADIX
alias FLT_EPSILON SINGLE_EPS;
//C     #define SINGLE_XMIN    FLT_MIN
alias FLT_RADIX SINGLE_BASE;
//C     #define SINGLE_XMAX    FLT_MAX
alias FLT_MIN SINGLE_XMIN;
//C     #define DOUBLE_DIGITS  DBL_MANT_DIG
alias FLT_MAX SINGLE_XMAX;
//C     #define DOUBLE_EPS     DBL_EPSILON
alias DBL_MANT_DIG DOUBLE_DIGITS;
//C     #define DOUBLE_XMAX    DBL_MAX
alias DBL_EPSILON DOUBLE_EPS;
//C     #define DOUBLE_XMIN    DBL_MIN
alias DBL_MAX DOUBLE_XMAX;
//C     #endif
alias DBL_MIN DOUBLE_XMIN;

//C     #endif /* R_EXT_CONSTANTS_H_ */
