/******************************************************************//**
 * \file src/interpreters/bnf/functions.d
 * \brief Functions for BNF
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module interpreters.bnf.functions;

import std.file, std.stdio, std.string, std.conv;
import interpreters.bnf.rule, interpreters.bnf.symbol;

Symbol[][] getAlternatives(string input){
  Symbol[][] alt;
  foreach(string alt_str; input.split(" | ")){
    Symbol[] symbols;
    if(alt_str.indexOf("(") > -1){
      string pre = alt_str[0 .. (alt_str.indexOf("("))];
      symbols ~= getAlternatives(pre)[0];
      string substring = alt_str[(alt_str.indexOf("(")+1) ..(alt_str.lastIndexOf(")")+2)];
      symbols ~= new Range(substring, getAlternatives(substring)[0]);
      alt_str = alt_str[(alt_str.lastIndexOf(")")+2) .. $];
    }
    foreach(string symb_str; alt_str.split(" ")){
      if(symb_str.length > 0)symbols ~= new Symbol(symb_str);
    }
    alt ~= symbols;
  }
  return alt;
}

Symbol[][] merge(Symbol[][] a, Symbol[][] b){
  Symbol[][] m;
  foreach(Symbol[] pos; b){
    foreach(Symbol[] apos; a){
     Symbol[] t = (apos ~ pos);
     m ~= t;
    }
  }
  return m;
}

size_t[] pathlength(Symbol[][] symbols){
  size_t[] lengths;
  foreach(Symbol[] s;symbols) lengths ~= s.length;
  return lengths;
}
