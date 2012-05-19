/**********************************************************************
 * src/io/csv/write.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Jan, 2012
 * first written Jan, 2012
 **********************************************************************/
module io.csv.write;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import core.arrays.matrix;

void writeFile(T)(T[][] m, string filename, bool overwrite = false, bool verbose = false){
  if(exists(filename)){
    if(overwrite){
      writefln(" - Overwriting file %s",filename);
      remove(filename);
    }else{
      writefln(" - WARNING: File already exists %s, results not saved",filename);
      return;
    }
  }
  try{
    string dirname;
    if(filename.lastIndexOf("/")) dirname = filename[0..filename.lastIndexOf("/")];
    if(!exists(dirname)) mkdirRecurse(dirname);
    auto fp = new File(filename,"wb");
    string      buffer;
    for (int r=0; r<m.length; r++) {
      for (int c=0; c<m[r].length; c++) {
        if(c!=0) fp.write("\t");
        fp.write(to!string(m[r][c]));
      }
      fp.writeln();
    }
    fp.close();
  }catch(Throwable e){
    writefln("File %s write exception: %s", filename,e);
  }
}
