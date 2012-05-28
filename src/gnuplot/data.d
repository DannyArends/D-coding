/******************************************************************//**
 * \file src/gnuplot/data.d
 * \brief GNU plot data container definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gnuplot.data;

import std.stdio, std.string, std.conv, std.file;
import core.arrays.matrix, core.typedefs.files;
import gnuplot.gnuaux;

//Container interface
interface GNUDCont{
  abstract string asMatrix();
  abstract string asXYZ();
  abstract void cleanup();
  @property abstract size_t rows();
  @property abstract size_t columns();
}

class GNUdata(T) : GNUDCont{
  T[][]    data;
  
  this(T[] data){ this(asmatrix(data)); }
  this(T[][] data){ this.data = translate(data); }
  
  string asMatrix(){
    if(datafile[0] == ""){
      datafile[0] = freefilename();
      auto fp = new File(datafile[0],"wb");
      foreach(size_t rcnt, T[] row;data){
        fp.writef("%s\t",(rcnt+1));
        foreach(size_t ccnt, T elem;row){
          if(ccnt > 0) fp.write("\t");
          fp.write(to!string(elem));
        }
        fp.write("\n");
      }
      fp.close();
    }
    return datafile[0];
  }
  string asXYZ(){ 
    if(datafile[1] == ""){
      datafile[1] = freefilename();
      auto fp = new File(datafile[1],"wb");
      foreach(size_t cntx, T[] row;data){
        foreach(size_t cnty, T elem;row){
          fp.writefln("%s %s %s", cntx, cnty, to!string(elem));
        }
        fp.write("\n");
      }
      fp.close();
    }
    return datafile[1]; 
  }
  
  void cleanup(){
    if(exists(datafile[0])) remove(datafile[0]);
    if(exists(datafile[1])) remove(datafile[1]);
  }

  @property size_t rows(){ return data.length; }
  @property size_t columns(){ return data[0].length; }

  private:
    string   datafile[2] = ["",""];
}
