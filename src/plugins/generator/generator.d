/**
 * \file generator.d
 *
 * Copyright (c) 2010 Danny Arends
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
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