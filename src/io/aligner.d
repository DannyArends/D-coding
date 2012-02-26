/******************************************************************//**
 * \file src/io/aligner.d
 * \brief Sequence alignment using BLAST
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.aligner;
 
import core.stdinc;
import io.xbin.reader;
import io.iofunctions;

extern (C) int system(char *);

/*! \brief Align DNA nucleotide sequences
 *
 * Align DNA nucleotide sequences. 
 * Old for tomato we use the 5th column (tab separated)
 * auto entities = buffer.split("\t");
 * entities[5][1..($-1)] ~ "\n");
 */
class Aligner{
public:
  this(string filename){
    input_filename=filename;
  }
  
  long nlines(string filename, bool header = true){
    string buffer;
    if(input_filename.isFile){
      auto f = new File(filename,"rb");
      long cnt=0;
      while(f.readln(buffer)){
        cnt++;
      }
      f.close();
      return cnt;
    }else{
      return 0;
    }
  }
  
  void doAlignment(string outfile = "seq.aligned",long batch_size = 500, bool header = true){
    string buffer;
    long counter = 0;
    auto t0 = Clock.currTime();
    if(exists(input_filename) && input_filename.isFile){
      if(exists(outfile) && outfile.isFile){
        writefln("Aligner: Overwriting previous output file '%s'",outfile);
        remove(outfile);
      }
      auto f = new File(input_filename,"rb");
      long nlines = nlines(input_filename);
      auto ftmp = new File(temp_filename,"wb");
      while(f.readln(buffer)){
        if(nlines < batch_size) batch_size = nlines-1;
        if(!header || counter != 0){
          ftmp.write(">p"~to!string(counter) ~"\n"~ buffer ~ "\n");
          if(counter % batch_size == 0){
            ftmp.close();
            writef("Aligner: Starting blast on %d sequences",(counter+1));
            string command = "blastn -subject=" ~ genome_name ~ " -query="~temp_filename~" -out="~temp_filename~".out -outfmt=6 -task="~task~" -evalue="~to!string(evalue) ~ "\0";
            int status = system(command.dup.ptr);
            if(status != 0){
              writefln("\n\nAligner ERROR: Blastn exit status: %d\n%s",status,command);
              break;
            }else{
              string output = readText(temp_filename ~ ".out");
              append(outfile,output);
              ftmp = new File(temp_filename,"wb");
              nlines = nlines-batch_size;
              writefln("...\nAligner: Blast finished (%d)",status);
            }
          }
        }
        counter++;
      }
      f.close();
      auto t1 = Clock.currTime();
      writefln("Aligner: %d sequences in %d", counter, (t1-t0));
    }else{
      writefln("Aligner: No such input file '%s'",input_filename);
    }
  }
  
  void cleanup(){
    if(exists(temp_filename) && temp_filename.isFile) remove(temp_filename);
    if(exists(temp_filename ~ ".out") && (temp_filename ~ ".out").isFile) remove(temp_filename ~ ".out");
  }
  
  bool setGenome(string filename){
    if(exists(filename) && filename.isFile){
      writefln("Aligner: Using genome file '%s'",filename);
      genome_name=filename;
      return true;
    }
    writefln("Aligner: No such genome file '%s'",filename);
    return false;
  }
  
private:
  string input_filename = "in.seq";
  string temp_filename = "fasta.txt";
  string genome_name = "ITAG2_genomic.fasta";
  string task = "blastn";
  double evalue = 0.0001;
}
