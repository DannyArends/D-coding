/**********************************************************************
 * \file src/core/io/iofunctions.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.io.iofunctions;
 
import std.stdio;
import std.conv;
import core.vararg;

//TODO: Easy :)
T[][] all(T)(T[][] t, string data, long row, long col, long rindex, long cindex){
  if(row==0 && col==0){
    t = new T[][1];
  }
  t[0] ~= to!T(data);
  return t;
}

//TODO: Easy :)
T[][] singleItem(T)(T[][] t, string data, long row, long col, long rindex, long cindex){
  if(row==rindex && col==cindex){
    auto returnval = new T[][1];
    returnval[0] ~= to!T(data);
    return returnval;
  }else{
    return null;
  }
}

//TODO: Medium :|
T[][] singleRow(T)(T[][] t, string data, long row, long col, long rindex, long cindex){
  if(row==rindex){
    if(col==0){
      t = new T[][1];
    }
    t[0] ~= to!T(data);
    return t;
  }else{
    return null;
  }
}

//TODO: Medium :|
T[][] singleColumn(T)(T[][] t, string data, long row,long col, long rindex, long cindex){
  if(col==cindex){
    if(row==0){
      t = new T[][1];
    }
    t[0] ~= to!T(data);
    return t;
  }else{
    return null;
  }
}

//TODO: Medium :|
T[][] subMatrix(T)(T[][] t, string data, long row,long col, ...){

}

//TODO: Hard :(
T[][] subMatrixRH(T)(T[][] t, string data, long row,long col, ...){

}

//TODO: Hard :(
T[][] subMatrixCH(T)(T[][] t, string data, long row,long col, ...){

}

//TODO: Hard :(
T[][] subMatrixRCH(T)(T[][] t, string data, long row,long col, ...){

}
