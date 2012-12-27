module examples.ex_heatmap;

import std.stdio, std.string, std.conv, std.math, std.file;
import gnuplot.gnuaux, gnuplot.data, gnuplot.output, gnuplot.plot;

void ex_heatmap(){
  int[][] data = [[1,2,3,4,4,0,4,6,7,6,6,6],
                  [6,3,3,5,4,5,4,6,0,5,1,1],
                  [1,4,6,4,4,5,4,4,7,5,2,6]];
  auto gnudata = new GNUdata!int(data);

  // Setup the gnuoutput on the output
  auto gnuoutput = GNUoutput(TERMINAL.PNG,"Example: Heatmap",["Row","Column"]);

  // Setup a plot using the gnudata
  gnuoutput.image(GNUplot(gnudata));

  gnudata.cleanup();
}
