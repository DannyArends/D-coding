/**********************************************************************
 * \file alignfasta/main.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio,std.conv;
import alignfasta.aligner;
 
void main(string[] args){
  writeln("Aligner v0.1");
  if(args.length > 2){
    Aligner my_align = new Aligner(args[1]);
    if(my_align.setGenome(args[2])){
      if(args.length > 3){
        my_align.doAlignment(args[3]);
      }else{
        my_align.doAlignment();
      }
    }
    my_align.cleanup();
  }else{
    writeln("-- Aligner --\n\nUse: ./aligner inputseq.txt genome.fasta [out.sequence]\n");
    writeln("  inputseq.txt - File with at each line an input sequence to align");
    writeln("  genome.fasta - Fasta genome file to which inputseq will be aligned");
    writeln("  out.sequence - Optional filename for output\n");
    writeln("(c) Danny Arends 2011");
  }
}
