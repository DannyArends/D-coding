/**********************************************************************
 * \file src/core/arrays/search.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.search;

import std.random;
 
pure uint[] range(int start, uint length){
  uint array[];
  for(uint i = 0; i < (length-1); i++){
   array ~= start+i;
  }
  return array;
}

uint[] randomrange(int start, uint length, int number){
  assert(number < length);
  return randomrange(range(start,length), number);
}

uint[] randomrange(uint[] range, int number){
  assert(number < range.length);
  uint[] s;
  foreach(e;randomSample(range, number)){
    s ~= e;
  }
  return s;
}

pure bool searcharray(T)(T[] haystack, T needle){
  foreach(T s; haystack){
    if(s==needle){
      return true;
    }
  }
  return false;
}
 
pure bool binsearcharray(T)(T[] haystack, T needle) {
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
