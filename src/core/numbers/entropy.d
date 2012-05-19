/******************************************************************//**
 * \file src/core/numbers/entropy.d
 * \brief Entropy functions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.numbers.entropy;

import std.stdio, std.math, std.file, std.path, std.string, std.conv;
import std.getopt;
import core.memory;

import core.arrays.ranges;
import core.arrays.types;

double[] entropy(T)(T[] bytes, uint base = 2, int size = 0){
  assert(bytes.length > 0, "Entropy: No bytes");
  if(size == 0 || size > bytes.length) size = bytes.length;
  double[] ret;
  uint block[2] = [0,0];
  uint[] counts;
  double p, logp;
  while(block[1] < bytes.length){
    counts = new uint[(T.max+1) - (T.min-1)];
    double sum = 0;
    foreach(T i; bytes[block[1] .. getI(block[1]+size,bytes)]){
      if(i >= T.min && i <= T.max) counts[i-(T.min-1)]++;
    }
  
    for(size_t i=0; i <= (T.max-T.min); i++){
      if(counts[i] == 0) continue;
      p    = to!double(counts[i])/size;
      logp = log2(p) / log2(base);
      sum -= p*logp;
    }
    ret ~= sum;
    block[0]++;
    block[1]=block[0]*size;
  }
  return ret;
}

void entropy(T)(string fn, File* fo, uint base = 2){
  assert(isFile(fn)     , "Entropy: No such a file");
  assert(getSize(fn) > 0, "Entropy: Empty file");
  ulong fileSize = getSize(fn);
  T[] inputbuffer;
  double[] e;
  try{
    auto fp = new File(fn,"rb");
    scope(exit) fp.close();
    inputbuffer = new T[cast(size_t)fileSize/(T.sizeof)];
    fp.rawRead!T(inputbuffer);
  }catch(Throwable t){
  }
  if(inputbuffer.length > 0){
    e = entropy!T(inputbuffer, base);
    fo.writef("\"%s\"\t%s\t\"%s\"\t", fn, fileSize,fn[lastIndexOf(fn,".")..$]);
    fo.writefln("%s\t%s", e[0], typeid(T));
  }
  freevector(inputbuffer);
  freevector(e);
  GC.collect();
  GC.minimize();
}
