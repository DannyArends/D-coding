/******************************************************************//**
 * \file src/core/arrays/types.d
 * \brief Array type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.arrays.vector;
import core.memory, std.random, std.conv;

pure T[] newvector(T)(size_t length, T value = T.init){
  T[] x;
  for(size_t j=0;j<length;j++){ x ~= value; }
  return x;
}

void freevector(T)(ref T[] v) {
  GC.removeRange(cast(void*)v);
  GC.free(cast(void*)v);
}

T sumvector(T)(in T[] v){
  T sum = to!T(0);
  foreach(e;v){ sum += e; }
  return sum;
}

pure T[] copyvector(T)(in T[] c){
  T[] x;
  x.length = c.length;
  for(size_t j=0; j < c.length;j++){
    x[j]=c[j];
  }
  return x;
}

/*
 * Splits a string by sep, and transforms each element to types of T
 */
T[] stringToVector(T)(string s, string sep= ","){
  string[] entities = s.split(sep);
  return stringToVector!T(entities);
}

/*
 * Convert a string vector to a vector of type T
 */
T[] stringToVector(T)(in string[] entities){
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

/*
 * Convert a vector of type T to a string
 */
string arrayToString(T)(in T[] entities, string sep = ":", bool conv=false){
  string retdata;
  for(auto e=0;e < entities.length; e++){
    if(e != 0) retdata ~= sep;
    if(conv){
      retdata ~= to!char(entities[e]);
    }else{
      retdata ~= to!string(entities[e]);
    }
  }
  return retdata;
}

T[] toType(T)(in ubyte[] buffer){
  T[] returnbuffer;
  foreach(int i, byte b ; buffer){
    returnbuffer ~= to!T(b);
  }
  return returnbuffer;
}

string toD(int x, size_t d = 6){
  string s = to!string(x);
  while(s.length < d){ s = "0" ~ s; }
  return s;
}

pure size_t[] dorange(uint start, size_t length){
  size_t array[];
  for(size_t i = 0; i < (length-1); i++){
    array ~= start+i;
  }
  return array;
}

pure T getIe(T)(size_t cnt, in T[] range){
  size_t l = range.length;
  if(cnt < l) return range[cnt];
  return getIe(cnt-l, range);
}

pure uint getI(T)(size_t cnt, in T[] range){
  size_t l = range.length;
  if(cnt < l) return cnt;
  return (l-1);
}


