import std.stdio, std.math, std.file, std.path, std.string, std.conv;
import std.getopt;
import core.memory;

import io.fasta;
import io.csv.write;
import core.numbers.entropy;
import core.arrays.matrix;

void main(string[] args){
  Fasta[] fastas = readFasta(args[1]);
  //writefln("Fastas: %s",fastas.length);
  double[][] matrix;
  foreach(Fasta f;fastas){
    if(f.sequence.length > 0){
      matrix ~= entropy!char(f.sequence.dup,4);
    }
  }
  writeFile!double(translate(matrix),"t.out",true,true);
}
