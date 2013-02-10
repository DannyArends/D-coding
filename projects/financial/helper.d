module financial.helper;

import std.stdio;
import std.string;
import std.conv;
import std.datetime;
import std.file;

alias core.thread.Thread.sleep  Sleep;
alias Clock.currTime            now;
alias std.string.split          strsplit;
alias std.array.replace         strrepl;
long  Msecs(SysTime t, SysTime t0 = now()){ return (t0-t).total!"msecs"(); }

immutable string requestFormat = "GET /%s HTTP/1.0\r\nHost: %s\r\n\r\n";
immutable string urlFormat = "finance/historical?q=%s&output=csv&startdate=Jan+1+%s&enddate=Dec+31+%s";

int[string] strtomonth;
string[int] monthtostr;
static this(){   
  strtomonth = [ 
    "Jan" : 1, "Feb" : 2, "Mar" : 3, "Apr" : 4,  "May" : 5,  "Jun" : 6, 
    "Jul" : 7, "Aug" : 8, "Sep" : 9, "Oct" : 10, "Nov" : 11, "Dec" : 12
  ];
  monthtostr = [ 
     1: "Jan", 2: "Feb", 3: "Mar", 4 : "Apr", 5 : "May", 6 : "Jun", 
     7: "Jul", 8: "Aug", 9: "Sep", 10: "Oct", 11: "Nov", 12: "Dec"
  ];
}

string createUrl(string company="AMS:AGN", int year=2010, bool verbose = false){
  if(verbose) writefln("%s", format(urlFormat, company, year, year));
  return format(urlFormat, company, year, year);
}

double tD(string s){
  try{ return(to!double(s));
  }catch(Exception e){
    return double.nan;
  }
}

uint tU(string s){
  try{ return(to!uint(s));
  }catch(Exception e){
    return -1;
  }
}

