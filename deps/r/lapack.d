/**
 * \file R.d - Wrapper for R.dll
 * Description: Wrapper for R.dll
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module r.lapack;

//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;

import std.c.stdlib;
import std.c.stdio;
import std.c.math;

immutable TOL = 1e-12;  // tolerance for linear regression

// Prototypes for the raw Fortran interface to BLAS
extern(C) {
  alias float f_float;
  alias double f_double;
  alias cfloat f_cfloat;
  alias cdouble f_cdouble;
  alias int f_int;

  void function(char *trans, f_int *m, f_int *n, f_int *nrhs, f_double *a, f_int *lda, f_double *b, f_int *ldb, f_double *work, f_int *lwork, f_int *info) dgels_;
  void function (f_int *m, f_int *n, f_int *nrhs, f_double *a, f_int *lda, f_double *b, f_int *ldb, f_double *s, f_double *rcond, f_int *rank, f_double *work, f_int *lwork, f_int *info)dgelss_;
  void function (char *transa, char *transb, f_int *m, f_int *n, f_int *k, f_double *alpha, f_double *A, f_int *lda, f_double *B, f_int *ldb, f_double *beta, f_double *C, f_int *ldc) dgemm_;
  void function (char *uplo, f_int *n, f_double *a, f_int *lda, f_int *info) dpotrf_;
  void function (char *uplo, f_int *n, f_int *nrhs, f_double *a, f_int *lda, f_double *b, f_int *ldb, f_int *info) dpotrs_;
}

static this(){
  HXModule blaslib = load_library("Rblas","blas");
  load_function(dgemm_)(blaslib,"dgemm_");
  writeln("Loaded BLAS functionality");
  
  HXModule lapacklib = load_library("Rlapack","lapack");
  load_function(dgels_)(lapacklib,"dgels_");
  load_function(dgelss_)(lapacklib,"dgelss_");
  load_function(dpotrf_)(lapacklib,"dpotrf_");
  load_function(dpotrs_)(lapacklib,"dpotrs_");
  writeln("Loaded LAPACK functionality");
}
