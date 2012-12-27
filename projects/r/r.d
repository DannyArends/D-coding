/******************************************************************//**
 * \file deps/r/r.d
 * \brief Wrapper for R statistical programming language
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module r.r;

import std.stdio, std.conv;
import libload.loader, libload.libload;

extern(C){
  void function(size_t argc, char **argv) Rf_initEmbeddedR;
  void function(size_t) Rf_endEmbeddedR;
  void function() R_SaveGlobalEnv;
  void function() GetRNGstate;
  void function() PutRNGstate;
  
  double function(double, double, double, int) dnorm;
  double function(double, double, double, int, int) qf;
}

static this(){//Load the functions when the module is loaded
  HXModule lib = load_library("R");
  
  load_function(GetRNGstate)(lib,"GetRNGstate");
  load_function(PutRNGstate)(lib,"PutRNGstate");  
  load_function(Rf_initEmbeddedR)(lib,"Rf_initEmbeddedR");
  load_function(Rf_endEmbeddedR)(lib,"Rf_endEmbeddedR");
  load_function(R_SaveGlobalEnv)(lib,"R_SaveGlobalEnv");
  
  load_function(dnorm)(lib,"Rf_dnorm4");
  load_function(qf)(lib,"Rf_qf");

  writeln("Loaded R functionality");
}
