module financial.prediction;

import std.stdio;
import std.array;
import std.algorithm;
import std.datetime;

import financial.company;
import statistics.regression;
import statistics.support;

void predictFuture(string name, Company company){
  Date[] keys = company.data.keys;
  sort!("a > b")(keys);
  double[][] dm;
  double[]   y, w;
  writef("%s:", name);
  foreach(cnt, key; keys){
    if(cnt < 3000){
      dm  ~= [1.0, key.month];
      y   ~= company.data[key].close;
      w   ~= 1;
      if(cnt != 0 && cnt % 300 == 0){
        Model[2] model = mregression(dm, y, w);
        writef(" %.2f", toLOD(model));
        stdout.flush();
      }
    }
  }
  writeln();
}

