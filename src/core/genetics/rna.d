/*
* rna.d
*/
module core.genetics.rna;

import std.stdio;

import core.genetics.dna;

enum RNA : char {U = 'U', G = 'G', A = 'A', C = 'C' };

alias RNA[]   RNAstrand;
alias RNA[3]  RNAcodon; 

pure RNA RNA_from_DNA(DNA base){
  switch(base){
    case DNA.T: return RNA.A; break;
    case DNA.C: return RNA.G; break;
    case DNA.A: return RNA.U; break;
    case DNA.G: return RNA.C; break;
  }
}

pure RNAstrand RNAstrand_from_DNAstrand(DNAstrand sequence){
  RNAstrand mRNA;
  DNAstrand antisense = DNAstrand_to_Antisense(sequence);
  foreach(DNA base; antisense){
    mRNA ~= RNA_from_DNA(base);
  }
  return mRNA;
}