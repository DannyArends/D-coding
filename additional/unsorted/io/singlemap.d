/**********************************************************************
 * \file src/io/singlemap.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module io.singlemap;
 
import core.stdinc;
import io.xbin.reader;
import io.iofunctions;

class SingleMap{
  string buffer;
  string[] names;
  string[] buffers;
  
  void readInNames(string filename){
    auto f = new File(filename,"rb");
    long cnt=0;
    if(filename.isFile){
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
    if(infile.isFile){
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
