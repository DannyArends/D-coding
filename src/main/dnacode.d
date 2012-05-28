/******************************************************************//**
 * \file src/main/dnacode.d
 * \brief Shared library loader
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.array, std.stdio, std.conv, std.string;
import genetics.dna, genetics.rna, genetics.protein;

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
    for(size_t x=0;x<1000;x++){
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
