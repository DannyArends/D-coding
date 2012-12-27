/******************************************************************//**
 * \file ebnf/rule.d
 * \brief BNF Rule definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ebnf.rule;

import std.file, std.stdio, std.string, std.conv;
import ebnf.symbol;

class Rule : Symbol{
  this(string val, Symbol[][] s){ super(val); alts = s; }
  
  override string toString(){
    string r = "Rule: " ~ value ~ " := ";
    foreach(size_t cnt, Symbol[] s; alts){
      if(cnt > 0) r ~= "\n      " ~ value ~ " := ";
      r ~= to!string(s);
    }
    return(r);
  }
  
  Symbol[][] alts;
}
