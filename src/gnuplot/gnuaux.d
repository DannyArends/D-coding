module gnuplot.gnuaux;

import std.stdio, std.string, std.conv, std.file;
import core.arrays.matrix;

extern (C) int system(char *);

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
  while(s.length < d){
    s = "0" ~ s;
  }
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
    writefln("[ERROR] No such file %s",filename);
  }else{
    try{
      auto fp = new File(filename,"rb");
      string      buffer;
      while(fp.readln(buffer)){
        buffer = chomp(buffer);
        data ~= stringvectortotype!T(buffer.split(sep));
      }
      fp.close();
      if(verbose) writefln("[DGNUplot] Parsed %s lines in file: %s",data.length, filename);
    }catch(Throwable e){
      writefln("[ERROR] File %s read exception: %s", filename,e);
    }
  }
  return data;
}