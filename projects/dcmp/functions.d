module dcmp.functions;

import std.stdio;

bool inTable(string n, string[] t){
  foreach(s; t){if(n==s) return true; }
  return false;
}

