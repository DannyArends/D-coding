/******************************************************************//**
 * \file src/core/arrays/matrix.d
 * \brief Fasta file type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.matrix;

import std.stdio;
import std.conv;
import std.math;

import core.arrays.types;

T[][] absmatrix(T)(T[][] i){
  T[][] m = newmatrix!T(i.length,i[0].length);
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m[r][c] = abs(i[r][c]);
    }
  }
  return m;
}

T[] unlist(T)(T[][] i){
  T[] m;
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m ~= i[r][c];
    }
  }
  return m;
}

T[][] asmatrix(T)(T[] i){
  T[][] m; T[]   row;
  for(size_t idx=0;idx<i.length;idx++){ row ~= i[idx]; }
  m ~= row;
  return m;
}

T[][] translate(T)(T[][] i){
  T[][] m = newmatrix!T(i[0].length,i.length);
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m[c][r] = i[r][c];
    }
  }
  return m;
}

void printmatrix(T)(T[][] m) {
  for(size_t r=0; r<m.length; r++) {
    for(size_t c=0; c<m[r].length; c++) {
      write(to!string(m[r][c])," ");
    }
    writeln();
  }
}

T[] stringvectortotype(T)(string[] entities){
  T[] rowleveldata;
  rowleveldata.reserve(entities.length);
  for(size_t e=0; e < entities.length; e++){
    try{
      rowleveldata ~= to!T(entities[e]);
    }catch(Throwable e){
      rowleveldata ~= T.init;
    }
  }
  return rowleveldata;
}
