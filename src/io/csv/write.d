/******************************************************************//**
 * \file src/io/csv/write.d
 * \brief CSV file writer
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jan, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.csv.write;

import std.stdio, std.string, std.file, std.conv;
import core.arrays.matrix, core.terminal;

void writeFile(T)(T[][] m, string filename, bool overwrite = false, bool verbose = false){
  if(exists(filename)){
    if(overwrite){
      WARN("Overwriting file %s",filename);
      remove(filename);
    }else{
      WARN("File already exists %s, results not saved",filename);
      return;
    }
  }
  try{
    string dirname;
    string buffer;
    if(filename.lastIndexOf("/")) dirname = filename[0..filename.lastIndexOf("/")];
    if(!exists(dirname)) mkdirRecurse(dirname);
    auto fp = new File(filename,"wb");
    for(size_t r=0; r < m.length; r++){
      for(size_t c=0; c < m[r].length; c++){
        if(c!=0) fp.write("\t");
        fp.write(to!string(m[r][c]));
      }
      fp.writeln();
    }
    fp.close();
  }catch(Throwable e){
    ERR("File %s write exception", filename);
  }
}
