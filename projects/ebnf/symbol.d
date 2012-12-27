/******************************************************************//**
 * \file src/interpreters/bnf/Symbol.d
 * \brief Symbol and Range definitions for BNF
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ebnf.symbol;

import std.file, std.stdio, std.string, std.conv;

enum BNFOP{NONE = '\0', OPT = '?', ANY = '*', ONE = '+'};

class Symbol{
  this(string val){
    val = strip(val);
    if(val.indexOf(")") > -1) val = val[0..(val.indexOf(")"))];
    if(val[($-1)] == BNFOP.OPT || val[($-1)] == BNFOP.ANY || val[($-1)] == BNFOP.ONE){
      operator = cast(BNFOP)(val[($-1)]);
      val = val[0..($-1)];
    }
    if(val.length >= 3 && val[0] == '\'' && val[($-1)] == '\''){
      val = val[1..($-1)];
      terminal = true;
    }
    value = val;
  }
  
  override string toString(){
    string r = value;
    r = terminal ?  "'" ~ r ~ "'" : "S(" ~ r ~ ")";
    if(operator != BNFOP.NONE) r ~= "[" ~ to!string(operator) ~ "]";
    return(r);
  }
  
  string  value;
  BNFOP   operator = BNFOP.NONE;
  bool    terminal = false;
}

class Range : Symbol{
  this(string val, Symbol[] s){ super(val); symbols = s; }

  override string toString(){
    string r = "R(" ~to!string(symbols.length) ~ "){ ";
    r ~= to!string(symbols);
    return(r ~ " }[" ~ to!string(operator)~"] ");
  }

  Symbol[] symbols;
}

