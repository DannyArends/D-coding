module dcmp.functions;

import std.stdio;

bool inTable(string n, string[] t){
  foreach(s; t){if(n==s) return true; }
  return false;
}

bool isRelOp(string s){
  if(s =="==") return true;
  if(s =="<>") return true;
  if(s =="<") return true;
  if(s ==">") return true;
  return false;
}

