/******************************************************************//**
 * \file ebnf/grammar.d
 * \brief BFNGrammar class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ebnf.grammar;

import std.file, std.stdio, std.string, std.conv;
import ebnf.rule, ebnf.functions, ebnf.symbol;

struct BNFGrammar{
  Rule[] rules;
  
  void load(string fn, bool verbose = true){
    assert(exists(fn),"File should exist");
    assert(isFile(fn),"Should be a file");

    string content = readText(fn);
    uint line_num;
    foreach(string line; content.split("\n")){
      if(line.indexOf(" := ") > 0){
        string[] temp = line.split(" := ");
        if(temp.length == 2){
          rules ~= new Rule(temp[0],getAlternatives(chomp(temp[1])));
        }else{
          if(verbose) writefln("[WARN] Invalid line %s, multiple ':=' found", line_num);
        }
      }else{
        if(verbose) writefln("[WARN] Invalid line %s, no ':=' found", line_num);
      }
      line_num++;
    }
  }

  Symbol[][] expand(Rule rule, size_t n = 1){ 
    assert(n > 0, "Rule expansion: N needs to be larger then 0");
    Symbol[][] exp_rule = rule.alts;
    size_t i = 0;
    while(i < n){
      i++;
      exp_rule = expand(exp_rule);
      writefln("expand %s = %s", i, exp_rule.length);
    }
    return exp_rule;
  }
  
  Symbol[][] expand(Symbol[][] symbols){
    Symbol[][] ret;
    foreach(Symbol[] s; symbols){
      Symbol[][] t = expand(s); ret ~= t;
    }
    return ret;
  }

  Symbol[][] expand(Symbol[] symbols){
    Symbol[][] ret = [[]];
    foreach(Symbol s; symbols){
      Symbol[][] t = expand(s); ret = merge(ret, t);
    }
    return ret;
  }

  Symbol[][] expand(Symbol s){
    if(s.value == "$") return [[]];
    foreach(Rule r; rules){ if(r.value == s.value) return r.alts; }
    return [[s]];
  }

  @property size_t length(){return rules.length; }
}

