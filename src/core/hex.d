/******************************************************************//**
 * \file src/core/hex.d
 * \brief Import file with hexadecimal functionality
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.hex;

import std.stdio;
import std.conv;
import std.math;
import std.string;

T fromhex(T)(string hexnr){
  T hexdigit(T)(char c){
    if(c >= '0' && c <= '9'){
      return c - '0';
    }else if(c >= 'a' && c <= 'f'){
      return 10 + c - 'a';
    }else{
      throw new Exception("Invalid hex digit: "~c);
    }
  }

  T sum = 0, multiplier = 1;
  foreach_reverse(c; toLower(hexnr)){
      sum += multiplier * hexdigit!T(c);
      multiplier *= 16;
  }
  return sum;
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    assert(fromhex!int("1") == 1);
    assert(fromhex!int("C") == 12);
    assert(fromhex!int("d") == 13);
    assert(fromhex!int("1A") == 26);
    assert(fromhex!double("5b8F") == 23_439.0);
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
