/*
* protein.d
*/
module core.genetics.protein;

import std.stdio;
import std.conv;

import core.genetics.rna;

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
  int tss;
  int end;
  
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

Protein[] Proteins_from_RNAstrand(RNAstrand sequence){
  Protein[] pArray;
  bool tssfound;
  int x = 1;
  Protein p;
  while(x < (sequence.length-2)){
    RNAcodon c = sequence[(x-1)..(x+2)];
    AA toElgonate = RNAcodon_to_AA(c);
    if(!tssfound && toElgonate == AA.Met){
      x = x+3;
      p.tss = x;
      tssfound = true;
    }else{
      if(tssfound){
        if(toElgonate == AA.STOP){
          tssfound = false;
          pArray ~= p;
          p.sequence.length = 0;
        }else{
          p.sequence ~= toElgonate;
          p.end = x+2;
          x+= 3;
        }
      }else{
        x++;
      }
    }
  }
  if(tssfound) pArray ~= p; //Save the currently elongating protein if we didn't find a stop
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
          break;
        case RNA.C: return AA.Ser; break;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Tyr;
          }
          return AA.STOP;
          break;
        case RNA.G:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Cys;
          }
          if(sequence[2] == RNA.G) return AA.Trp;
          return AA.STOP;
          break;        
      }
    break;
    case RNA.C:
      switch(sequence[1]){
        case RNA.U: return AA.Leu;break;
        case RNA.C: return AA.Pro; break;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.His;
          }
          return AA.Gln;
          break;        
        case RNA.G: return AA.Arg; break;
      }
    break;
    case RNA.A:
      switch(sequence[1]){
        case RNA.U:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C || sequence[2] == RNA.A ){
            return AA.Ile;
          }
          return AA.Met;
          break;      
        case RNA.C: return AA.Thr; break;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Asn;
          }
          return AA.Lys;
          break;            
        case RNA.G:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Ser;
          }
          return AA.Arg;
          break;   
      }
    break;
    case RNA.G:
      switch(sequence[1]){
        case RNA.U: return AA.Val; break;
        case RNA.C: return AA.Ala; break;
        case RNA.A:
          if(sequence[2] == RNA.U || sequence[2] == RNA.C  ){
            return AA.Asp;
          }
          return AA.Glu;
          break;           
        case RNA.G: return AA.Gly; break;
      }
    break;  
  }
}
