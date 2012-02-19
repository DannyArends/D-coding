/**********************************************************************
 * \file src/core/numbers/primes.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Feb, 2012
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.numbers.primes;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.random;

bool prime(long n){
  if(n < 2) return false;
  if(n == 2) return true;
  for(long t=2;t <= sqrt(n);t++){
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
    for(uint t=2;t < 50;t++){
      if(prime(t)) write(" ",t);
    }
    writeln("\n [1000,10000,20000] = ",xthprime([1000,10000,20000]));
    writeln("OK: ",__FILE__);  
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
