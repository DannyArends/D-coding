/******************************************************************//**
 * \file src/io/reader.d
 * \brief Abstract Reader class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.reader;

import io.csv.parse;
import io.cmdline.parse;

Reader initialize(Settings settings){
  switch(settings.getString("--format")){
    default:
    break;
  }
  return new CSVreader();
}

abstract class Reader{
  abstract T[][] load(T)(string filename);
}
