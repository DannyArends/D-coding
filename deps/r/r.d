/**
 * \file R.d - Wrapper for R.dll
 * 
 * Description: 
 *   Wrapper for R.dll
 *
 * Copyright (c) 2010 Danny Arends
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module r.r;

//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

import std.c.stdlib;
import std.c.stdio;
import std.c.math;
import r.Rconfig;
import r.r_ext.Arith;
import r.r_ext.Boolean;
import r.r_ext.Complex;
import r.r_ext.Constants;
import r.r_ext.Error;
import r.r_ext.Memory;
import r.r_ext.Print;
import r.r_ext.Random;
import r.r_ext.Utils;
import r.r_ext.RS;

import core.libload.libload;

//R_internals.h

enum  SEXPTYPE : uint {
    NILSXP	= 0,	/* nil = NULL */
    SYMSXP	= 1,	/* symbols */
    LISTSXP	= 2,	/* lists of dotted pairs */
    CLOSXP	= 3,	/* closures */
    ENVSXP	= 4,	/* environments */
    PROMSXP	= 5,	/* promises: [un]evaluated closure arguments */
    LANGSXP	= 6,	/* language constructs (special lists) */
    SPECIALSXP	= 7,	/* special forms */
    BUILTINSXP	= 8,	/* builtin non-special forms */
    CHARSXP	= 9,	/* "scalar" string type (internal only)*/
    LGLSXP	= 10,	/* logical vectors */
    INTSXP	= 13,	/* integer vectors */
    REALSXP	= 14,	/* real variables */
    CPLXSXP	= 15,	/* complex variables */
    STRSXP	= 16,	/* string vectors */
    DOTSXP	= 17,	/* dot-dot-dot object */
    ANYSXP	= 18,	/* make "any" args work */
    VECSXP	= 19,	/* generic vectors */
    EXPRSXP	= 20,	/* expressions vectors */
    BCODESXP	= 21,	/* byte code */
    EXTPTRSXP	= 22,	/* external pointer */
    WEAKREFSXP	= 23,	/* weak reference */
    RAWSXP	= 24,	/* raw bytes */
    S4SXP	= 25,	/* S4 non-vector */
    FUNSXP	= 99	/* Closure or Builtin */
};

extern (C):
//Rmath.h
typedef double function(double, double, double, int) fpdnorm;
typedef double function(double, double, double, int, int) fppnorm;
typedef double function(double, double, double, int, int) fpqnorm;
typedef double function(double, double) fprnorm;
typedef double function(double) fplgamma;
typedef double function(double, double, double, int, int) fpqf;

fpdnorm			dnorm;
fppnorm			pnorm;
fpqnorm			qnorm;
fprnorm			rnorm;
fplgamma    gammln;
fpqf        qf;

static this(){
  HXModule lib = load_library("R");
  dnorm = load_function!fpdnorm(lib,"Rf_dnorm4");
  pnorm = load_function!fppnorm(lib,"Rf_pnorm5");
  qnorm = load_function!fpqnorm(lib,"Rf_qnorm5");
  rnorm = load_function!fprnorm(lib,"Rf_rnorm");
  gammln = load_function!fplgamma(lib,"Rf_lgammafn");
  qf = load_function!fpqf(lib,"Rf_qf");
  writeln("Mapped R.dll");
}