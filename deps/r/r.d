/**********************************************************************
 * \file deps/r/r.d - Wrapper for R
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 
module r.r;

private import std.loader;
private import std.stdio;
private import std.conv;

import libload.libload;

const HAVE_F77_UNDERSCORE = 1;

const IEEE_754 = 1;
const SUPPORT_UTF8 = 1;
const SUPPORT_MBCS = 1;
const ENABLE_NLS = 1;

extern(C){
  //These are the functions we map to D from Rmath.h
  double function(double, double, double, int) dnorm;
  double function(double, double, double, int, int) qf;
}

//Load the functions when the module is loaded
static this(){
  HXModule lib = load_library("R");
  load_function(dnorm)(lib,"Rf_dnorm4");
  load_function(qf)(lib,"Rf_qf");
  writeln("Loaded R functionality");
}
