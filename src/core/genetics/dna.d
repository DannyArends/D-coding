/*
* dna.d
*/
module core.genetics.dna;

import std.stdio;
import std.string;

enum DNA : char {A = 'A', C = 'C', T = 'T', G = 'G' };

alias DNA[]   DNAstrand;
alias DNA[3]  DNAcodon;

/* Check if base is valid DNA code */
bool is_valid_DNA(char base){
	if (base == DNA.A) return true;
	if (base == DNA.C) return true;
	if (base == DNA.T) return true;
	if (base == DNA.G) return true;
  writeln("Warning: invalid base: " ~ base);
	return false;
}

DNAstrand DNA_from_string(string seq){
  DNAstrand sequence;
  foreach(char c; seq.toUpper){
    if(is_valid_DNA(c)) sequence ~= cast(DNA)(c);
  }
  return sequence;
}

pure DNA DNA_to_Anti(DNA base){
  switch(base){
    case DNA.T: return DNA.A; break;
    case DNA.C: return DNA.G; break;
    case DNA.A: return DNA.T; break;
    case DNA.G: return DNA.C; break;
    default: break;
  }
  assert(0);
}

pure DNAstrand DNAstrand_to_Antisense(DNAstrand sequence){
  DNAstrand antisense;
  foreach(DNA base; sequence){
    antisense ~= DNA_to_Anti(base);
  }
  return antisense;
}
