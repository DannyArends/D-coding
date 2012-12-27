/******************************************************************//**
 * \file src/gnuplot/gnuaux.d
 * \brief GNU plot aux definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gnuplot.gnuaux;

import std.stdio, std.string, std.conv, std.file;
import dcode.arrays.matrix, dcode.arrays.vector, dcode.types;

struct GNUtype{
  string   type;
  string[] supports;
  bool     haswith;
  bool opCmp(GNUtype c){ return type is c.type; }
}

enum TYPE: GNUtype{
  I    = GNUtype("impulses"     , ["linetype"], true),
  H    = GNUtype("histogram"    , ["linetype"], false),
  P    = GNUtype("points"       , ["pointtype"], true),
  L    = GNUtype("lines"        , ["linetype"],true),
  LP   = GNUtype("linespoints"  , ["linetype","pointtype"],true),
  FC   = GNUtype("filledcurves" , ["linetype"],true),
  CS   = GNUtype("candlesticks" , ["linetype"],true)
}

struct GNUout{
  string terminal;
  string ext;
  uint   size[2] = [640,480];
  bool opCmp(GNUout c){ return ext is c.ext; }
}

enum TERMINAL: GNUout{
  EPS  = GNUout("postscript eps enhanced","eps"),
  GIF  = GNUout("gif","gif"),
  JPG  = GNUout("jpeg","jpg"),
  PNG  = GNUout("png","png"),
  PS   = GNUout("postscript","ps"),
  SVG  = GNUout("svg","svg"),
  SVGI = GNUout("svg enhanced mouse","svg")
}

T[][] parseCSV(T)(string filename, string sep="\t", bool verbose = true){
  T[][] data;
  if(!exists(filename) || !isFile(filename)){
    writefln("No such file %s",filename);
  }else{
    try{
      auto fp = new File(filename,"rb");
      string      buffer;
      while(fp.readln(buffer)){
        buffer = chomp(buffer);
        data ~= stringToVector!T(buffer.split(sep));
      }
      fp.close();
      if(verbose) writefln("Parsed %s lines in file: %s",data.length, filename);
    }catch(Throwable e){
      writefln("File %s read exception: %s", filename,e);
    }
  }
  return data;
}
