/**
 * \file iofunctions.D
 *
 * Abstracted functions that can be applied to build a custom object matrix internally used to representa a any-sized object
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends, Joeri v/d Velde, Pjotr Prins, Karl W. Broman, Ritsert C. Jansen
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
 * Contains: singleItem, singleRow, singleColumn, subMatrix
 * 
 **/
module core.io.iofunctions;
 
import std.stdio;
import std.conv;
import core.vararg;

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
