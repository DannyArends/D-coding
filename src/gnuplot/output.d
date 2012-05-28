/******************************************************************//**
 * \file src/gnuplot/output.d
 * \brief GNU plot output device definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gnuplot.output;

import std.stdio, std.string, std.conv, std.file;
import core.executor, core.terminal;
import core.arrays.ranges;
import gnuplot.gnuaux, gnuplot.plot;

struct GNUoutput{
  GNUout device   = TERMINAL.PNG;
  string title    = "<No Title>";
  string[] labels = ["<No X axis>", "<No Y axis>", "<No Z axis>"];
  bool legend     = false;
  bool grid       = false;

  string plot(GNUplot gnuplot, int range[2] = [-1,-1]){
    auto fp = setup();
    gnuplot.plot(fp, range);
    fp.close();
    execute(gnuplot);
    return plotfile;
  }
  
  string splot(GNUplot gnuplot, bool fill = false){
    auto fp = setup();
    gnuplot.splot(fp, fill);
    fp.close();
    execute(gnuplot);
    return plotfile;
  }
  
  string image(GNUplot gnuplot){
    auto fp = setup();
    gnuplot.image(fp);
    fp.close();
    execute(gnuplot);
    return plotfile;
  }
  
  @property uint[] size(uint s[2]){ 
    if(s != [0,0]) device.size=s;
    return device.size; 
  }
  
  private:
    
    File* setup(){
      outfile  = freefilename("script","scp");
      plotfile = freefilename("plot",device.ext);
      auto fp = new File(outfile,"wb");
      fp.writefln("set term %s size %s,%s", device.terminal, device.size[0], device.size[1]);
      fp.writefln("set output '%s'",plotfile);
      fp.writefln("set xlabel \"%s\"", getIe(0,labels));
      fp.writefln("set ylabel \"%s\"", getIe(1,labels));
      fp.writefln("set zlabel \"%s\"", getIe(2,labels));
      fp.writefln("set title  \"%s\"", title);
      if(grid) fp.writefln("set grid");
      if(legend){
        fp.writefln("set key top left");
        fp.writefln("set key box");
      }
      return fp;    
    }

    void execute(GNUplot gnuplot){
      int rc = system(("gnuplot " ~ outfile ~ "\0").dup.ptr);
      if(rc == 0){
        cleanup();
        MSG("Created: %s",plotfile);
      }else{
        ERR("Plot failed: %s, script saved",plotfile);
      }
    }
    
    void cleanup(){ remove(outfile); }

    string outfile;
    string plotfile;
}
