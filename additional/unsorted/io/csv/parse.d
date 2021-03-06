/******************************************************************//**
 * \file src/io/csv/parse.d
 * \brief CSV implementation of the Abstract Reader class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.csv.parse;

import std.stdio, std.string, std.file, std.conv;
import core.arrays.matrix, core.terminal, io.reader;

class CSVreader : Reader{
  
  T[][] load(T)(string fn = "phenotypes.csv"){ return parseFile!T(fn,sep); }

  T[][] parseFile(T)(string filename, sep="\t", bool verbose = false){
    T[][] data;
    if(!exists(filename) || !isFile(filename)){
      ERR("No such file %s",filename);
    }else{
      try{
        auto fp = new File(filename,"rb");
        string      buffer;
        while(fp.readln(buffer)){
          string[] elements = chomp(buffer).split("\t");
          if(header){
            rowlabels = elements;
            header = false;
          }else{
            assert(elements.length > 0, "CSV: No elements");
            if(rownames){
              assert(elements.length > 1, "CSV: No elements after rowname");
              rowlabels ~= elements[0];
              elements = elements[1..$];
            }
            data ~= stringvectortotype!T(elements);
          }
        }
        fp.close();
        if(verbose) MSG("Parsed %s imports from file: %s",data.length, filename);
      }catch(Throwable e){
        ERR("File %s read exception", filename);
      }
    }
    return data;
  }

  private:
    string   sep      = "\t";
    bool     header   = false;
    bool     rownames = false;
    string[] rowlabels;
    string[] collabels;
}
