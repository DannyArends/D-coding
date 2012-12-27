/******************************************************************//**
 * \file src/io/fasta.d
 * \brief Fasta file type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.fasta;

import std.stdio, std.math, std.file, std.path, std.string, std.conv;
import core.arrays.matrix, core.terminal, core.arrays.types;
import core.arrays.ranges;

/*! \brief Fasta sequence structure
 *
 *  Structure that holds a single fasta sequence 
 */
struct Fasta{
  string description;     /*!< Fasta sequence description */
  string sequence;        /*!< Fasta sequence */
  bool circular = false;  /*!< Is the sequence circular ? */
}

Fasta[] readFasta(string fn, bool circular = false){
  assert(isFile(fn)     , "readFasta: No such a file");
  assert(getSize(fn) > 0, "readFasta: Empty file");

  auto lines = splitLines(readText(fn));
  Fasta[] fastas;
  int     cnt  = 0;
  bool    desc = false;
  bool    sequ = false;
  string  description = "";
  string  sequence = "";
  foreach(string line; lines){
    line = chomp(line);
    if(line == ""){ 
      if(sequ || sequence != ""){
        fastas ~= Fasta(description,sequence,circular);
        sequ = false;
        sequence = "";
      }
      desc=false; sequ=false; 
    }
    if(line[0]=='>' || line[0]==';'){
      if(sequ || sequence != ""){
        fastas ~= Fasta(description,sequence,circular);
        sequ = false;
        sequence = "";
      }
      if(!desc) description = "";
      description ~= line[1..$];
      desc = true;
    }else{
      if(desc || sequ){
        desc = false; sequ = true;
        sequence ~= strip(line);
      }
    }
  }
  fastas ~= Fasta(description, sequence, circular);
  return fastas;
}

void shiftSequence(Fasta f, uint n = 0, bool verbose = true){
  assert(n < f.sequence.length,"Faste: shift >= sequence.length");
  if(n==0) return;
  MSG("Moving sequence: %s...%s", f.sequence[0..10], f.sequence[($-10)..$]);
  if(f.circular){
    if(n > 0) f.sequence = f.sequence[n..$] ~ f.sequence[0..n];
    if(n < 0) f.sequence = f.sequence[($-n)..$] ~ f.sequence[0..($-n)];
  }else{
    string mask = to!string(newvector!char(n,'X'));
    if(n > 0) f.sequence = f.sequence[n..$] ~ mask;
    if(n < 0) f.sequence = mask ~ f.sequence[0..($-n)];    
  }
  MSG("New sequence: %s...%s", f.sequence[0..10], f.sequence[($-10)..$]);
}
