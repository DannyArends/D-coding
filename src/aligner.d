/**
 * \file fileloader.d
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: main
 * 
 **/

import std.stdio;
import std.conv;

import core.io.aligner;
 
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
