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

import std.stdio, std.conv, std.math;
import core.arrays.types;

pure T[][] absmatrix(T)(in T[][] i){
  T[][] m = newmatrix!T(i.length,i[0].length);
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m[r][c] = abs(i[r][c]);
    }
  }
  return m;
}

pure T[] unlist(T)(in T[][] i){
  T[] m;
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m ~= i[r][c];
    }
  }
  return m;
}

pure T[][] asmatrix(T)(in T[] i){
  T[][] m; T[]   row;
  for(size_t idx=0;idx<i.length;idx++){ row ~= i[idx]; }
  m ~= row;
  return m;
}

pure T[][] translate(T)(in T[][] i){
  T[][] m = newmatrix!T(i[0].length,i.length);
  for(size_t r=0;r<i.length;r++){
    for(size_t c=0;c<i[0].length;c++){
      m[c][r] = i[r][c];
    }
  }
  return m;
}

void printmatrix(T)(in T[][] m) {
  for(size_t r=0; r<m.length; r++) {
    for(size_t c=0; c<m[r].length; c++) {
      write(to!string(m[r][c])," ");
    }
    writeln();
  }
}

T[] stringvectortotype(T)(in string[] entities){
  T[] rowleveldata;
  for(size_t e=0; e < entities.length; e++){
    try{
      rowleveldata ~= to!T(entities[e]);
    }catch(Throwable e){
      rowleveldata ~= T.init;
    }
  }
  return rowleveldata;
}
