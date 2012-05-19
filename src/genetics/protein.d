/******************************************************************//**
 * \file src/genetics/protein.d
 * \brief Protein type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Feb, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module genetics.protein;

import std.stdio, std.conv;
import genetics.rna;

enum AA : string  {START = "START", STOP = "STOP", 
          Phe = "Phe", Leu = "Leu", Ser = "Ser", 
          Tyr = "Tyr", Cys = "Cys", Trp = "Trp", 
          Pro = "Pro", His = "His", Gln = "Gln",
          Ile = "Ile", Met = "Met", Asn = "Ans",
          Lys = "Lys", Arg = "Arg", Asp = "Asp", 
          Glu = "Glu", Val = "Val", Ala = "Ala", 
          Gly = "Gly", Thr = "Thr"};

struct Protein{
  AA[] sequence;
  uint tss;
  uint end;

  this(uint start){
    tss=start;
  }
  
  string toString(){
    string ret;
    if(tss != -1){
      ret ~= "Protein: [" ~ to!string(tss-1) ~":" ~ to!string(tss+1) ~ "] [" ~ to!string(end) ~ "] [";
    }else{
      ret ~= "No Protein\n[";
    }
    foreach(int i, AA aa;sequence){
      if(i > 0) ret ~= ", ";
      ret ~= aa;
    }
    return ret ~"]";
  }
};

Protein ScanProtein(RNAstrand sequence, uint start, bool circular){
  Protein p = Protein(start);
  AA toElongate;
  uint x = start;
  int lapped = 0;
  while(toElongate != AA.STOP && x <= (sequence.length-2)){
    RNAcodon codon = sequence[(x-1)..(x+2)];
    toElongate = RNAcodon_to_AA(codon);
    p.sequence ~= toElongate;
    x = x+3;
    if(x > (sequence.length-2) && circular){
      x = x-(cast(uint)(sequence.length)-2);
      lapped++;
    }
    if(lapped == 3){
      writeln("WARN: Infinitely long protein at: [" ~ to!string(start-1) ~":" ~ to!string(start+1) ~ "]");
      break;
    }
  }
  p.end = x;
  return p;
}

/*
 * Converts an RNA strand and searches for all possible proteins
 */
Protein[] Proteins_from_RNAstrand(RNAstrand sequence, bool circular = false){
  Protein[] pArray;
  bool tssfound;
  uint x = 1;
  while(x < (sequence.length-2)){
    RNAcodon codon = sequence[(x-1)..(x+2)];
    if(RNAcodon_to_AA(codon) == AA.Met){
      pArray ~= ScanProtein(sequence, x, circular);
    }
    x++;
  }
  return pArray;
}

/*
 * Converts an RNA codon to an AA
 */
AA RNAcodon_to_AA(RNAcodon sequence){
  switch(sequence[0]){
    case RNA.U:
      switch(sequence[1]){
        case RNA.U: 
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Phe;
          }
          return AA.Leu;
        case RNA.C: return AA.Ser;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Tyr;
          }
          return AA.STOP;
        case RNA.G:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Cys;
          }
          if(sequence[2] == RNA.G) return AA.Trp;
          return AA.STOP;
          default: break;          
      }
    break;
    case RNA.C:
      switch(sequence[1]){
        case RNA.U: return AA.Leu;
        case RNA.C: return AA.Pro;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.His;
          }
          return AA.Gln;
        case RNA.G: return AA.Arg;
        default: break;
      }
    break;
    case RNA.A:
      switch(sequence[1]){
        case RNA.U:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C || sequence[2] == RNA.A ){
            return AA.Ile;
          }
          return AA.Met;
        case RNA.C: return AA.Thr;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Asn;
          }
          return AA.Lys;
        case RNA.G:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Ser;
          }
          return AA.Arg;
          default: break;          
      }
    break;
    case RNA.G:
      switch(sequence[1]){
        case RNA.U: return AA.Val;
        case RNA.C: return AA.Ala;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Asp;
          }
          return AA.Glu;
        case RNA.G: return AA.Gly;
        default: break;
      }
    break;
    default: break;
  }
  assert(0);
}
