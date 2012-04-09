/******************************************************************//**
 * \file src/core/numbers/primes.d
 * \brief Functions for prime numbers
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.numbers.primes;

import std.stdio;
import std.conv;
import std.datetime;
import std.math;
import std.string;
import std.random;

bool prime(real n){
  if(n < 2) return false;
  if(n == 2) return true;
  real sqrtn = sqrt(n);
  for(real t=2;t <= sqrtn;t++){
    if(n % t == 0) return false;
  }
  return true;
}

uint[] xthprime(uint[] x){
  uint[] primes;
  uint   pn = 0;
  long   pp = 0;
  foreach(uint n ; x.sort){
    uint sn = n;
    n = n - pn;
    while(n != 0){
      pp++;
      if(prime(pp)) n--;
    }
    primes ~= cast(uint)pp;
    pn = sn;
  }
  return primes;
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    SysTime t_s = Clock.currTime();
    for(uint t=2;t < 500_000;t++){
      prime(t); //write(" ",t);
    }
    writefln("2 .. 500k checked for primes in %s msecs",(Clock.currTime()-t_s).total!"msecs"());
    writeln("\n [1000,10000,20000] = ",xthprime([1000,10000,20000]));
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
