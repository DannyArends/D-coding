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
import core.arrays.matrix, core.terminal;

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

string toD(int x, int d){
  string s = to!string(x);
  while(s.length < d){ s = "0" ~ s; }
  return s;
}

string freefilename(string stem = "temp", string ext = "dat", uint digits = 6){
  int dataid = 0;
  string filename;
  do{
    filename = stem ~ toD(dataid, digits) ~ "." ~ ext;
    dataid++;
  }while(exists(filename));
  return filename;
}

T[][] parseCSV(T)(string filename, string sep="\t", bool verbose = true){
  T[][] data;
  if(!exists(filename) || !isFile(filename)){
    ERR("No such file %s",filename);
  }else{
    try{
      auto fp = new File(filename,"rb");
      string      buffer;
      while(fp.readln(buffer)){
        buffer = chomp(buffer);
        data ~= stringvectortotype!T(buffer.split(sep));
      }
      fp.close();
      if(verbose) MSG("Parsed %s lines in file: %s",data.length, filename);
    }catch(Throwable e){
      ERR("File %s read exception: %s", filename,e);
    }
  }
  return data;
}
