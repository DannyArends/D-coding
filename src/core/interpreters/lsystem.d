/*
 * lsystem.d - Interpreter for an L-system in D
 * 
 * See: http://en.wikipedia.org/wiki/P'' or http://www.cs.unibo.it/~martini/PP/bohm-jac.pdf
 * Copyright (c) 2010 Danny Arends
 * 
 */

module core.interpreters.lsystem;

import std.array;
import std.stdio;
import std.conv;

class lsystemrule(Element, Sequence){
public:
  this(Element hd, Sequence tl) {
    head = hd; 
    tail = tl;
  }
  
  bool isMatch(Element hd) {
    return hd == head;
  }
  
  Sequence getTail() {
    return tail;
  }
  
private:
  Element head;
  Sequence tail;
}

class Lsystem(Element, Sequence){
public:
    void setState(Sequence st) {
      state = st;
    }
    
    Sequence getState() {
      return state;
    }
   
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
  Lsystem!(char, string) test = new Lsystem!(char, string)();
   
  test.setState("X");
  test.addRule('X', "F-[[X]+X]+F[+FX]-X");
  test.addRule('F', "FF");
  for(int i = 0; i < 5; i++){
    test.iterate();
    writefln("After itteration %d: %s",i,test.getState());
  }
}
