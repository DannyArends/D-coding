module dcode.io.textreader;

import std.stdio, std.file, std.conv;
import dcode.io.reader;

class TextReader : Reader {
  T[]   readAsVector(T)(string filename, char sep = '\n'){
    T[] r;
    if(!exists(filename) || !filename.isFile) return r;
    filesize  = cast(uint)getSize(filename);
    inbuffer  = new ubyte[buffersize];
    auto fp   = new File(filename,"rb");
    while(fp.rawRead(inbuffer)){
      si = 0;
      foreach(size_t i, byte b ; inbuffer){
        if(cast(char)b == sep) addElement!T(r, inbuffer[si .. (i-1)], i);
      }
      bcnt++;
    }
    writefln("'%s', %s buffers, %s elements, %s lines, %s errors", filename, bcnt, (ecnt-errs), lcnt, errs);
    return r;
  }

  T[][] readAsMatrix(T)(string filename, char[2] seps = ['\t','\n']){
    T[][] r;
    if(!exists(filename) || !filename.isFile) return r;
    filesize  = cast(uint)getSize(filename);
    inbuffer  = new ubyte[buffersize];
    auto fp   = new File(filename,"rb");
    while(fp.rawRead(inbuffer)){
      si = 0;
      T[] row;
      foreach(size_t i, byte b ; inbuffer){
        if(cast(char)b == seps[0]){
          addElement!T(row, inbuffer[si .. (i-1)], i);
        }else if(cast(char)b == seps[1]){
          addElement!T(row, inbuffer[si .. (i-1)], i);
          r ~= row;
          lcnt++; 
          row.length = 0;
        }
      }
      bcnt++;
    }
    writefln("'%s', %s buffers, %s elements, %s lines, %s errors", filename, bcnt, (ecnt-errs), lcnt, errs);
    return r;
  }

  void addElement(T)(ref T[] inp, ubyte[] elem, int i){
    try{
      inp ~= to!T(cast(string)elem);
    }catch(Throwable e){ errs++; }
    si = i; ecnt++;
  }
  
  protected:
  int     filesize;
  int     si   = 0; // Start index of current element
  int     lcnt = 0; // Number of lines
  int     ecnt = 0; // Number of elements
  int     bcnt = 0; // Number of buffers
  int     errs = 0; // Number of errors
  ubyte[] inbuffer;
}

