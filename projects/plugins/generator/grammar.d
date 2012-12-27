/******************************************************************//**
 * \file src/plugins/generator/grammar.d
 * \brief Grammar definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.generator.grammar;

import std.stdio, std.math;

/*! \brief Basic grammar structure
 *
 *  Defines a representation of grammar
 */
struct Grammar{
  Rule[] rules;
}

alias string function(string,string) Fun;

struct Rule{
  Fun fun;
  string apply(R, I, O)(string input, string output){ 
    return fun(input,output);
  }
}

/*
  Regex!char from;
  string to;
struct Word : Rule{ }
struct Phrase : Rule{ }
struct Clause : Rule{ }
*/
