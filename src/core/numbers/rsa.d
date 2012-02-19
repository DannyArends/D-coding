/**********************************************************************
 * \file src/core/numbers/rsa.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Feb, 2012
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.numbers.rsa;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.random;

import core.numbers.primes;
import core.numbers.utils;

long getE(long N, uint[] pq){
  long x = (N/2);
  long coprime = (pq[0]-1) * (pq[1]-1);
  while(x < N && gcd!long(x,coprime) != 1){
    x++;
    while(!prime(x)) x++;
  }
  return x;
}

long getD(long e, uint[] pq){
  long coprime = (pq[0]-1) * (pq[1]-1);
  long d = 1;
  while((e*d) % coprime != 1){ d++; }
  return d;
}

struct Cypher{
  uint pq[];
  long N;
  long keypublic;
  long keyprivate;
  
  void print(){
    writeln("\nPublic Key:\t",N,"-",keypublic);
    writeln("Private Key:\t",N,"-",keyprivate);
    writeln("----");
    writeln("Prime seeds:\t",pq);
    writeln("----");
  }
}

Cypher generatekey(uint[] range=[1000,10000], bool fixed = false, bool verbose = false){
  Cypher c;
  uint[] pn;
  if(!fixed){
    pn ~= uniform(range[0], range[1]);
    pn ~= uniform(range[0], range[1]);
    while(pn[0]==pn[1]){ pn[0] = uniform(range[0], range[1]); }
  }else{
    pn = range;
  }
  c.pq = xthprime(pn);
  writeln("[RSA] Prime numbers generated: ",pn);
  c.N = c.pq[0] * c.pq[1];
  c.keypublic  = getE(c.N, c.pq);
  writeln("[RSA] Public key created: ",c.keypublic);
  c.keyprivate = getD(c.keypublic, c.pq);
  writeln("[RSA] Private key created: ",c.keyprivate);
  return c;
}

long[] encrypt(string msg, Cypher c){
  long[] encoded;
  foreach(l; msg){
    encoded ~= modpow!long(to!uint(l), c.keypublic, c.N);
  }
  writeln("[ENC] Encoded: ", msg);
  return encoded;
}

string decrypt(long[] msg, Cypher c){
  string decoded = "";
  foreach(l; msg){
    try{
      decoded ~= to!char(modpow!long(l, c.keyprivate,c.N));
    }catch(Throwable t){
      writeln("[DEC] Overflow error: ",modpow!long(l, c.keyprivate,c.N));
    }
  }
  writeln("[DEC] Decoded: ", decoded);
  return decoded;
}

unittest{
  writeln("Unit test: ",__FILE__);
  try{
    
    //Fixed key from 5th and 9th prime number
    Cypher c = generatekey([5,9],true);
    c.print();
    long[] encmsg = encrypt("Hello world with fixed cypher",c);
    string decmsg = decrypt(encmsg,c);
    
    //Random key made from primes between 1000th and 2000th prime number
    Cypher c2 = generatekey([1000,2000]);
    c2.print();
    encmsg = encrypt("Some other string with a random cypher",c2);
    decmsg = decrypt(encmsg,c2);
    
    writeln("OK: ",__FILE__);
  }catch(Throwable e){
    string err = to!string(e).split("\n")[0];
    writefln(" - %s\nFAILED: %s",err,__FILE__);  
  }
}
