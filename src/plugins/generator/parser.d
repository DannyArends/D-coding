/******************************************************************//**
 * \file src/plugins/generator/parser.d
 * \brief Parser definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Mar, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.generator.parser;

import std.stdio, std.math;

/*! \brief Interface to define a parser
 *
 *  Interface to define a parser
 */
interface AbstractParser{
public:
  bool parse(string input, Grammer g){
  
  }
}
