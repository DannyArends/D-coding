/**
 * \file searching.D
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: doRange, searchArray, searchArrayBinary
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module core.arrays.searching;

import std.random;
 
pure uint[] doRange(int start,uint length){
  uint array[];
  for(uint i = 0; i < (length-1); i++){
   array ~= start+i;
  }
  return array;
}

uint[] doRandomRange(int start, uint length, int number){
  assert(number < length);
  return doRandomRange(doRange(start,length),2);
}

uint[] doRandomRange(uint[] range, int number){
  assert(number < range.length);
  uint[] s;
  foreach(e;randomSample(range,number)){
    s ~= e;
  }
  return s;
}

pure bool searchArray(T)(T[] haystack, T needle){
  foreach(T s; haystack){
    if(s==needle){
      return true;
    }
  }
  return false;
}
 
pure bool searchArrayBinary(T)(T[] haystack, T needle) {
  uint first = 0;
  uint last = (haystack.length-1);
  while (first <= last) {
    if(last==first) return (needle==haystack[first]);
    uint mid = (first + last) / 2;
    if (needle > haystack[mid]){
      first = mid + 1;
    }else if (needle < haystack[mid]){
      last = mid - 1;
    }else{
      return true;
    }
  }
  return false;
}
