/******************************************************************//**
 * \file src/plugins/generator/generator.d
 * \brief Generator definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.generator.generator;

import std.stdio;
import std.math;

interface AbstractGenerator{
public:
  bool generate(){
  
  }
}

class Generator : AbstractGenerator{
public:
  override bool generate(){
  
  }
  
  bool loadTemplates(string path = "./data/templates"){
  
  }
  
private:
  Template[] templates;
}
