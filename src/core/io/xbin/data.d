/**
 * \file xbin/data.d
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
 * Contains: DataSet, DataEntry
 * 
 **/
module core.io.xbin.data;

import std.math; 
import std.stdio;
import std.array;
import std.string;

enum Type : int { 
  EMPTY = 0, 
  INTMATRIX = 1, 
  DOUBLEMATRIX = 2, 
  FIXEDCHARMATRIX = 3, 
  VARCHARMATRIX = 4, 
  MATRIXREFERENCE = 5 
}

class DataEntry{
  // name read property
  @property string name() { return m_name; }
  // type read property
  @property int type() { return m_type; }
  
  // name write property
  string name(string value) { return m_name = value; }

  private:
    string   m_name;
    Type     m_type = Type.EMPTY;

  /**
       *
       * Unit test for the xbinary_format class
       *       
       **/
  unittest{
  
  }
}

class DataSet{
  // footprint equality read property
  bool footprint() { return (m_sfootprint==m_efootprint); }
  // version read property
  int[] myversion() { return m_version; }
  // name read property
  string name() { return m_name; }
  // payload read property
  DataEntry[] payload() { return m_payload; }

  // name write property
  string name(string value) { return m_name = value; }
  // payload write property
  DataEntry[] payload(DataEntry[] value) { return m_payload = value; }

  private:
    byte[2]     m_sfootprint = [ 0, 5 ];
    int[3]      m_version = [ 0, 0, 1 ];
    string      m_name;
    DataEntry[]   m_payload;
    byte[2]     m_efootprint = [ 0, 5 ];

  /**
       *
       * Unit test for the xbinary_format class
       *       
       **/
  unittest{
  
  }
}
