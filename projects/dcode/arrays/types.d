/******************************************************************//**
 * \file src/core/arrays/types.d
 * \brief Array type definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module dcode.arrays.types;
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

pure T[] copyvector(T)(in T[] c){
  T[] x;
  x.length = c.length;
  for(size_t j=0; j < c.length;j++){
    x[j]=c[j];
  }
  return x;
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

