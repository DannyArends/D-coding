/******************************************************************//**
 * \file src/genetics/rna.d
 * \brief RNA type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module genetics.rna;

import std.stdio;

import genetics.dna;

enum RNA : char {U = 'U', G = 'G', A = 'A', C = 'C' };

alias RNA[]   RNAstrand;
alias RNA[3]  RNAcodon; 

pure RNA RNA_from_DNA(DNA base){
  switch(base.getBase()){
    case DNABASES.T.getBase(): return RNA.A;
    case DNABASES.C.getBase(): return RNA.G;
    case DNABASES.A.getBase(): return RNA.U;
    case DNABASES.G.getBase(): return RNA.C;
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
