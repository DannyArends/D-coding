/******************************************************************//**
 * \file src/core/arrays/search.d
 * \brief Array search and ranges
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.search;

import std.stdio, std.conv, std.string, std.random;

pure T[] range(T)(T start, uint length){
  T array[];
  for(uint i = 0; i < length; i++){
   array ~= start+i;
  }
  return array;
}

pure T[] array(T)(int length, T value){
  T array[];
  for(int i = 0; i < length; i++){
   array ~= value;
  }
  return array;
}

T[] randomrange(T)(T start, uint length, int number){
  assert(number < length);
  return randomrange!T(range(start,length), number);
}

T[] randomrange(T)(T[] range, int number){
  assert(number < range.length);
  T[] s;
  foreach(e;randomSample(range, number)){ s ~= e; }
  return s;
}

pure T[] removearray(T)(T[] haystack, size_t idx = -1){
  if(idx == -1) return haystack;
  T[] nobjs;
  for(size_t x=0; x < haystack.length; x++){
    if(idx != x) nobjs ~= haystack[x];
  }
  return nobjs;
}

pure bool searcharray(T)(T[] haystack, T needle){
  return(getIndex(haystack,needle) != -1);
}

pure size_t getIndex(T)(T[] haystack, T needle){
  foreach(idx, T s; haystack){
    if(s==needle){
      return idx;
    }
  }
  return -1;
}
 
pure bool binsearcharray(T)(T[] haystack, T needle) {
  return(getIndexB(haystack,needle) != -1);
}

pure size_t getIndexB(T)(T[] haystack, T needle) {
  size_t first = 0;
  size_t last = (haystack.length-1);
  while (first <= last) {
    if(last==first){
      if(needle==haystack[first]) return first;
      return -1;
    }
    size_t mid = (first + last) / 2;
    if (needle > haystack[mid]){
      first = mid + 1;
    }else if (needle < haystack[mid]){
      last = mid - 1;
    }else{
      return mid;
    }
  }
  return -1;
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    assert(array!int(5,3)[2] == 3);
    assert(array!int(5,3).length == 5);
    assert(range!int(5,3).length == 3);
    assert(range!int(5,3)[2] == 7);
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
