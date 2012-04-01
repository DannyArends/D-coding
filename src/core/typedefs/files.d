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

import std.stdio;
import std.conv;
import std.file;

enum FileStatus{ NOTHING = 0, IS_FILE = 1, IS_DIR = 2 }

FileStatus checkFile(string filename){
  if(!exists(filename)) return FileStatus.NOTHING;
  if(!isFile(filename)) return FileStatus.IS_DIR;
  return FileStatus.IS_FILE;
}
