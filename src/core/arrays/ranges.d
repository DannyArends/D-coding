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

pure uint[] dorange(uint start, size_t length){
  uint array[];
  for(size_t i = 0; i < (length-1); i++){
    array ~= start+i;
  }
  return array;
}

pure T getIe(T)(size_t cnt,T[] range){
  size_t l = range.length;
  if(cnt < l) return range[cnt];
  return getIe(cnt-l, range);
}

pure uint getI(T)(size_t cnt,T[] range){
  size_t l = range.length;
  if(cnt < l) return cnt;
  return (l-1);
}
