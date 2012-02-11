/**********************************************************************
 * \file src/core/genetics/rna.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.genetics.rna;

import std.stdio;

import core.genetics.dna;

enum RNA : char {U = 'U', G = 'G', A = 'A', C = 'C' };

alias RNA[]   RNAstrand;
alias RNA[3]  RNAcodon; 

pure RNA RNA_from_DNA(DNA base){
  switch(base.getBase()){
    case DNABASES.T.getBase(): return RNA.A; break;
    case DNABASES.C.getBase(): return RNA.G; break;
    case DNABASES.A.getBase(): return RNA.U; break;
    case DNABASES.G.getBase(): return RNA.C; break;
    default: break;
  }
  assert(0);
}

RNAstrand RNAstrand_from_DNAstrand(DNAstrand sequence){
  RNAstrand mRNA;
  DNAstrand antisense = DNAstrand_to_Antisense(sequence);
  foreach(DNA base; antisense){
    mRNA ~= RNA_from_DNA(base);
  }
  return mRNA;
}