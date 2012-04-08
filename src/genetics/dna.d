/******************************************************************//**
 * \file src/genetics/dna.d
 * \brief DNA type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module genetics.dna;

import std.stdio;
import std.math;
import std.conv;
import std.string;
import std.algorithm;
import std.random;

import core.arrays.search;

/*! \brief DNA type definition
 *
 *  DNA type definition
 */
struct DNA{
public:
  this(char base){
    this.base=base;
  }
  
  pure char getBase(){
    return base;
  }
  
  string toString(){
    return to!string(base);
  }
  
  bool opCmp(DNA c){
    return base==c.base;
  }
  
private:
  char base;
};

enum DNABASES : DNA {ANY = DNA('#'), A = DNA('A'), C = DNA('C'), T = DNA('T'), G = DNA('G') };

alias DNA[]          DNAstrand;
alias DNA[3]         DNAcodon;

/* Check if base is valid DNA code */
bool is_valid_DNA(char base){
  if (base == DNABASES.A.getBase())   return true;
  if (base == DNABASES.C.getBase())   return true;
  if (base == DNABASES.T.getBase())   return true;
  if (base == DNABASES.G.getBase())   return true;
  if (base == DNABASES.ANY.getBase()) return true;
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
  switch(base.getBase()){
    case DNABASES.T.getBase(): return DNABASES.A;
    case DNABASES.C.getBase(): return DNABASES.G;
    case DNABASES.A.getBase(): return DNABASES.T;
    case DNABASES.G.getBase(): return DNABASES.C;
    case DNABASES.ANY.getBase(): return DNABASES.ANY;
    default: break;
  }
  assert(0);
}

DNA randomBase(DNA base){
  ulong z;
  switch(base.getBase()){
    case DNABASES.A.getBase():   z = dice(1, 33, 33, 33); break;
    case DNABASES.G.getBase():   z = dice(33, 1, 33, 33); break;
    case DNABASES.T.getBase():   z = dice(33, 33, 1, 33); break;
    case DNABASES.C.getBase():   z = dice(33, 33, 33, 1); break;
    case DNABASES.ANY.getBase(): z = dice(25, 25, 25, 25); break;
    default: z = dice(25, 25, 25, 25);
  }
  switch(z){
    case 0: return DNABASES.A;
    case 1: return DNABASES.G;
    case 2: return DNABASES.T;
    case 3: return DNABASES.C;
    default: break;
  }
  assert(0);
}

DNAstrand Elongate_DNA(DNAstrand sequence, double elongation_rate = 0.01){
  DNAstrand elongated_strand = sequence;
  if(uniform(0.0, 1.0) < elongation_rate){
    if(dice(50, 50) == 0){
      elongated_strand = randomBase(DNABASES.ANY) ~ elongated_strand;
    }else{
      elongated_strand = elongated_strand ~ randomBase(DNABASES.ANY);
    }
  }
  return elongated_strand;
}

DNAstrand Mutate_DNA(DNAstrand sequence, double mutation_rate = 0.0001){
  DNAstrand mutated_strand;
  foreach(DNA base; sequence){
    if(uniform(0.0, 1.0) < mutation_rate){
      mutated_strand ~= randomBase(base);
    }else{
      mutated_strand ~= base;
    }
  }
  return mutated_strand;
}

DNAstrand[] CrossOver_DNA(DNAstrand[] strands, double crossover_rate = 0.7){
  if(uniform(0.0, 1.0) < crossover_rate){
    assert(strands.length >= 2);
    uint[] s = randomrange!uint(to!uint(0),cast(uint)strands.length,2);
    uint breakpoint = cast(uint)uniform(0, min(strands[s[0]].length,strands[s[1]].length));
    strands[s[0]] = strands[s[0]][0..breakpoint-1] ~ strands[s[1]][breakpoint-1.. $];
    strands[s[1]] = strands[s[1]][0..breakpoint-1] ~ strands[s[0]][breakpoint-1.. $];
  }
  return strands;
}

DNAstrand replicate_DNAstrand(DNAstrand templatestrand, double error_rate = 0.00000001){
  return DNAstrand_to_Antisense(templatestrand, error_rate);
}

DNAstrand DNAstrand_to_Antisense(DNAstrand sequence, double error_rate = 0){
  DNAstrand antisense;
  foreach(DNA base; sequence){
    if(uniform(0.0, 1.0) < error_rate){
      antisense ~= randomBase(DNA_to_Anti(base));
    }else{
      antisense ~= DNA_to_Anti(base);
    }
  }
  return antisense;
}
