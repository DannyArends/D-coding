module core.io.fasta;
 
import std.math; 
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;
import std.datetime;
import core.time;
import core.vararg;

import core.io.xbin.reader;
import core.io.iofunctions;

extern (C) int system(char *);  // Tango's process hangs sometimes

class FastaReader{
  string buffer;

  void createFasta(string filename, string outfile){
    auto f = new File(filename,"rb");
    auto ftmp = new File("fasta.txt","wb");
    long cnt = 0;
    if(isfile(filename)){
      while(f.readln(buffer)){
        if(cnt != 0){
          auto entities = buffer.split("\t");
          ftmp.write(">p"~to!string(cnt) ~"\n"~ entities[5][1..($-1)] ~ "\n");
          if(cnt % 500 == 0){
            ftmp.close();
            writef("blast %d",cnt);
            string command = "blastn -subject=ITAG2_genomic.fasta -query=fasta.txt -out=tmp.out -outfmt=6 -task=blastn -evalue=0.0001\0";
            int status = system(command.dup.ptr);
            string output = readText("tmp.out");
            append(outfile,output);
            ftmp = new File("fasta.txt","wb");
            write("... done");
          }
        }
        cnt++;
      }
    }
    f.close();
  }
}