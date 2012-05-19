/******************************************************************//**
 * \file src/interpreters/lsystem.d
 * \brief Interpreter for an L-system (http://en.wikipedia.org/wiki/Lsystem)
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module interpreters.lsystem;

import std.array, std.stdio, std.conv;

class lsystemrule(Element, Sequence){
public:
  this(Element hd, Sequence tl){
    head = hd; 
    tail = tl;
  }
  
  bool     isMatch(Element hd){ return hd == head; }
  Sequence getTail(){ return tail; }
  
private:
  Element head;
  Sequence tail;
}

class Lsystem(Element, Sequence){
public:
    void setState(Sequence st){ state = st; }
    Sequence getState(){ return state; }
   
    void addRule(Element hd, Sequence tl){
      rules ~= new lsystemrule!(Element,Sequence)(hd, tl);
    }
   
    Sequence replace(Element hd){
      Sequence seq;
      for(int i = 0; i < rules.length; i++){
         if(rules[i].isMatch(hd)){
           return rules[i].getTail();
         }
      }
      seq = hd ~ seq;
      return seq;
    }
    
    void iterate(){
      Sequence newstate;
      for(int i = 0; i < state.length; i++){
         Sequence replacement = replace(state[i]);
         for(int e = 0; e < replacement.length; e++){
            newstate = replacement[e] ~ newstate;
         }
     }
     state = newstate;
    }
    
  private:
    Sequence state;
    lsystemrule!(Element, Sequence)[] rules;
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    Lsystem!(char, string) test = new Lsystem!(char, string)();
     
    test.setState("X");
    test.addRule('X', "F-[[X]+X]+F[+FX]-X");
    test.addRule('F', "FF");
    for(int i = 0; i < 5; i++){
      test.iterate();
    }
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
