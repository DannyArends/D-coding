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
import plugins.generator.grammar;

/*! \brief Class/Interface to define a parser
 *
 *  Class/Interface to define a parser
 */
class Parser{
public:
  bool parse(string input, Grammar g){
    bool valid = true;
    foreach(Rule r; g.rules){ valid = valid && r.apply!(bool,string,void*)(input,null); }
    return valid;
  }
}
