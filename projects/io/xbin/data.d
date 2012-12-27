/******************************************************************//**
 * \file src/io/xbin/data.d
 * \brief XBIN data definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.xbin.data;

import std.math, std.stdio, std.array, std.string;

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
