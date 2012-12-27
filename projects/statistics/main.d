/******************************************************************//**
 * \file statistics/main.d
 * \brief Main function for rake app::regression
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio, std.math, std.datetime, core.time;
import dcode.arrays.search, statistics.regression, statistics.statistics;
import dcode.io.reader, dcode.io.textreader;

void print_usage(){
  writeln("   Usage: correlation in.csv buffersize");
  writeln("   Supported buffersize: 2mb, 4mb, 16mb, 64mb, 256mb");
  writeln("   e.g.: correlation ./test/data.csvr 2mb");
}

void main(string[] args){
  writefln("Multiple linear regression in D\n");
  double[][] designmatrix = [[1,1],[1,1],[1,2],[1,2],[1,2],[1,2]];
  double[]   trait = [4,1,3,7,5,6];
  double[]   weight = [1,1,1,1,1,1];
  int[]      nullmodellayout = [1,1];  //The D[][1] is dropped from the model to test its predictive value 
  for(size_t i = 0; i < designmatrix.length; i++){
    writefln("[%s] = %s",trait[i],designmatrix[i]);
  }
  writeln();
  writefln("LOD = %s",multipleregression(designmatrix,trait,weight,nullmodellayout,0));
  TextReader reader = new TextReader();
  if(args.length > 2){
    switch(args[2]){
      case "2mb"  :reader.buffersize = BUFFER.S2MB;  break;
      case "4mb"  :reader.buffersize = BUFFER.S4MB;  break;
      case "16mb" :reader.buffersize = BUFFER.S16MB; break;
      case "64mb" :reader.buffersize = BUFFER.S64MB; break;
      case "256mb":reader.buffersize = BUFFER.S256MB;break;
      default     :reader.buffersize = BUFFER.S16KB; break;
    }
    auto data = reader.readAsMatrix!double(args[1]);
    writeln("Correlation algorithm 1");
    auto t1 = Clock.currTime();
    foreach(a; data){
      foreach(b; data){ 
        correlation_v2!double(a,b);
      }
      writeln(".");
    }
    auto t2 = Clock.currTime();
    writef("\nFast %d\n", (t2-t1));
    writeln("Correlation algorithm 2");
    auto t3 = Clock.currTime();
    foreach(a; data){
      foreach(b; data){ 
        correlation_v2!double(a,b);
      }
      writeln(".");
    }
    auto t4 = Clock.currTime();
    writefln("\nSlow %d\n", (t4-t3));
  }else{
    print_usage();
  }
}
