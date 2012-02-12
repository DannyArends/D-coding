/**********************************************************************
 * \file src/core/arrays/search.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.arrays.search;

import std.stdio;
import std.conv;
import std.string;
import std.random;

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

