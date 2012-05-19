/******************************************************************//**
 * \file src/core/arrays/ranges.d
 * \brief Fasta file type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.ranges;

import std.math;

pure uint[] dorange(int start, size_t length){
  uint array[];
  for(uint i = 0; i < (length-1); i++){
    array ~= start+i;
  }
  return array;
}

uint getI(T)(size_t cnt,T[] range){
  int l = range.length;
  if(cnt < l) return cnt;
  return (l-1);
}

pure T[] doarray(T)(int length, T value){
  T array[];
  for(int i = 0; i < (length-1); i++){
   array ~= value;
  }
  return array;
}
