/******************************************************************//**
 * \file src/core/typedefs/files.d
 * \brief file status definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Mar, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.files;

import std.stdio, std.conv, std.file, core.typedefs.types;

string freefilename(string stem = "temp", string ext = "dat", uint digits = 6, string dir="/"){
  int dataid = 0;
  string filename;
  do{
    filename = stem ~ toD(dataid, digits) ~ "." ~ ext;
    dataid++;
  }while(exists(dir ~ filename));
  return filename;
}
