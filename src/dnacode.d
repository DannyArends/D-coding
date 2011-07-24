/*
* DNAcode.d
*/
import std.array;
import std.stdio;
import std.conv;
import std.string;
import core.genetics.dna;
import core.genetics.rna;
import core.genetics.protein;

void print_usage(){
  writeln("   Usage: dnacode DNAstrand");
  writeln("   e.g.: dnacode AAAATGATTGAGTAGGATGGATTCTATATCTCTACTCATTTTGTCGCTT");
}

void main(string[] args){
  if(args.length > 1){
    DNAstrand dna = DNA_from_string(args[1]);
    RNAstrand rna = RNAstrand_from_DNAstrand(dna);
    Protein[] p = Proteins_from_RNAstrand(rna);
    writefln("%s\n%s\n%s",dna,rna,p);
    for(int x=0;x<1000;x++){
      dna = Elongate_DNA(dna);
      dna = Mutate_DNA(dna);
    }
    rna = RNAstrand_from_DNAstrand(dna);
    p = Proteins_from_RNAstrand(rna);
    writefln("%s\n%s\n%s",dna,rna,p);
  }else{
    print_usage();
  }
}
