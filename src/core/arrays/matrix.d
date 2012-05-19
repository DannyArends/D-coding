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
  for(uint r=0;r<i.length;r++){
    for(uint c=0;c<i[0].length;c++){
      m[r][c] = abs(i[r][c]);
    }
  }
  return m;
}

T[] unlist(T)(T[][] i){
  T[] m;
  m.reserve(i.length * i[0].length);
  for(uint r=0;r<i.length;r++){
    for(uint c=0;c<i[0].length;c++){
      m ~= i[r][c];
    }
  }
  return m;
}

T[][] asmatrix(T)(T[] i){
  T[][] m;
  T[] row;
  for(uint idx=0;idx<i.length;idx++){
    row ~= i[idx];
  }
  m ~= row;
  return m;
}

T[][] translate(T)(T[][] i){
  T[][] m = newmatrix!T(i[0].length,i.length);
  for(uint r=0;r<i.length;r++){
    for(uint c=0;c<i[0].length;c++){
      m[c][r] = i[r][c];
    }
  }
  return m;
}

void printmatrix(T)(T[][] m) {
  for (int r=0; r<m.length; r++) {
    for (int c=0; c<m[r].length; c++) {
      write(to!string(m[r][c])," ");
    }
    writeln();
  }
}

T[] newvector(T)(size_t dim, T value = 0) {
  T[] v;
  v.reserve(dim);
  if(v is null){
    writeln("Not enough memory for new vector of dimension %d",(dim+1));
  }
  for(int e=0; e<dim; e++){
    v[e] = cast(T)value;
  }
  return v;
}

T[] stringvectortotype(T)(string[] entities){
  T[] rowleveldata;
  rowleveldata.reserve(entities.length);
  for(auto e=0;e < entities.length; e++){
    try{
      rowleveldata ~= to!T(entities[e]);
    }catch(Throwable e){
      rowleveldata ~= to!T(0);
    }
  }
  return rowleveldata;
}
