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

void main(string[] args){
  DNAstrand dna = DNA_from_string(args[1]);
  RNAstrand rna = RNAstrand_from_DNAstrand(dna);
  Protein[] p = Proteins_from_RNAstrand(rna);
  writefln("%s\n%s\n%s",dna,rna,p);
  
}
