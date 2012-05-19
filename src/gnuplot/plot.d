module gnuplot.plot;

import std.stdio, std.string, std.conv, std.file;
import core.arrays.matrix, core.arrays.ranges;
import gnuplot.gnuaux, gnuplot.data;

struct GNUplot{
  GNUDCont  data;
  string[]  l_title  = ["Unknown"];
  TYPE[]    p_type   = [TYPE.LP];
  string[]  l_spec   = ["pointtype"];
  uint[]    l_type   = [5];
  uint      p_rgb[3] = [7,5,15];
  
  void plot(File* fp, int range[2] = [-1,-1]){
    range = init_range(range);
    string datafile = data.asMatrix();
    fp.writefln("set style data %s",getIe(0,p_type).type);
    fp.writefln("set xrange [-0.5:%s]",(data.rows));
    usercommands(fp);
    for(size_t cnt=range[0]; cnt <= range[1]; cnt++){
      int idx = (cnt-1);
      if(cnt == 1){ fp.write("plot ");
      } else {      fp.writeln(",\\"); }
      fp.writef("\"%s\" using %s title \"%s\"", datafile, (cnt+1), getIe(idx,l_title));
      if(getIe(idx,p_type).haswith){
        fp.writef(" with %s %s %s", getIe(idx,p_type).type, getIe(idx,l_spec), getIe(idx,l_type));
      }
    }
    fp.writeln("");
  }
  
  void splot(File* fp, bool fill = false){
    string datafile = data.asXYZ();
    fp.writefln("set xrange [1:%s]",(data.rows));
    fp.writefln("set yrange [1:%s]",(data.columns));
    if(fill){
      fp.writefln("set pm3d implicit at s");
      fp.writefln("set hidden3d");
    }else{
      fp.writefln("set style data %s",p_type[0].type);
    }
    
    usercommands(fp);
    
    fp.writefln("splot \"%s\"", datafile);
  }
  
  void image(File* fp){
    string datafile = data.asXYZ();
    
    fp.writefln("set view map");
    fp.writefln("set border 0");
    fp.writefln("set palette rgbformulae %s,%s,%s",p_rgb[0], p_rgb[1], p_rgb[2]);
    
    fp.writefln("set yrange [-0.5:%s.5]",(data.columns-1));
    fp.writefln("set xrange [0.5:%s.5]",(data.rows-1));
    
    usercommands(fp);
    
    fp.writefln("splot \"%s\" using 1:2:3 with image", datafile);
  }
  
  void addCmd(string cmd){ userplotcommands ~= cmd; }
  
  private:
    int[2] init_range(int range[2] = [-1,-1]){
      if(range[0]==-1) range[0] = 1;
      if(range[1]==-1) range[1] = data.columns;
      return range;
    }

    void usercommands(File* fp){
      foreach(string cmd; userplotcommands){
        fp.writeln(cmd);
      }
    }
    
    string[] userplotcommands;
}
