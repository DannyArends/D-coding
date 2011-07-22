module core.io.singlemap;
 
import std.math; 
import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;
import std.datetime;
import core.time;
import core.vararg;

import core.io.xbin.reader;
import core.io.iofunctions;

class SingleMap{
  string buffer;
  string[] names;
  string[] buffers;
  
  void readInNames(string filename){
    auto f = new File(filename,"rb");
    long cnt=0;
    if(isfile(filename)){
      while(f.readln(buffer)){
        buffers ~= strip(buffer);
        names ~= buffer.split(" ")[0];
        cnt++;
      }
    }
    writefln("names: %d %d",names.length,cnt);
    f.close();
  }
  
  void writeOutput(string infile, string outfile){
    auto f = new File(infile,"rb");
    long cnt = 0;
    uint id=1;
    auto fout = new File(outfile,"wb");
    if(isfile(infile)){
      while(f.readln(buffer)){
        if(cnt == to!long(strip(names[id]))){
          if(id%1000==0)writefln("%d %d %s",cnt,id,names[id]);
          fout.write(replace(buffers[id][0..($-1)],regex(" ","g"), "\t") ~ "\t" ~ buffer);
          id++;
        }
        cnt++;
      }
    }
    fout.close();
  }
  
}