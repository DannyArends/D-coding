module financial.finance;

import std.stdio;
import std.datetime;
import std.getopt;
import std.algorithm;

import financial.helper;
import financial.download;
import financial.company;
import financial.prediction;

void printHelp(){
  writeln("Usage ./financial [options]\n");
  writeln(" -h[elp]      Show this help");
  writeln(" -f[rom]      Data from this year (default -2 years)");
  writeln(" -u[pdate]    Update to today (downloads the current year)");
}

void main(string[] args){
  writeln("Financial prediction software\n");
  bool help;
  bool update;
  int from = -2;
  getopt(args, "help|h", &help
             , "update|u", &update
             , "from|f", &from);
  if(from <= 0) from += now().year;
  if(from < 1900 || from > now().year){
    writefln("Unknown start year: %s", from);
    return;
  }
  Company[string] companies = loadCompanies();
  companies.downloadHistory(from, update);
  writefln("- Data analysis");
  foreach(key, company; companies){
    predictFuture(key, company);
  }
}

