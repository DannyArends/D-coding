module examples.ex_lineplot;

import std.stdio, std.string, std.conv, std.math, std.file;
import gnuplot.gnuaux, gnuplot.data, gnuplot.output, gnuplot.plot;

void ex_lineplot(){
  int[] data        = [1,2,3,4,4,4,0,6,7,5,5,5];
  auto gnudata      = new GNUdata!int(data);

  // Setup the gnuoutput on the output
  auto gnuoutput    = GNUoutput(TERMINAL.PNG,"Example: Lineplot",["X","Y"]);
  gnuoutput.legend  = true;

 // Setup a the plots using the gnudata object
  gnuoutput.plot(GNUplot(gnudata,["Just a lonely line"]));
  gnuoutput.plot(GNUplot(gnudata,["Histogram"],[TYPE.H],TYPE.H.supports));
  gnudata.cleanup();
  
  int[][] data2     = [[1,2,3,4,4,4,4,6,7,6,6,6],
                       [6,3,3,5,9,5,4,6,0,5,1,1],
                       [1,4,6,4,4,5,4,4,7,5,2,6]];
  auto gnudata2     = new GNUdata!int(data2);

  // Setup a the plots using the gnudata2 object
  gnuoutput.plot(GNUplot(gnudata2,["Line 1","Line 2","Line 3"]));
  gnuoutput.plot(GNUplot(gnudata2,["S1","S2","S3"],[TYPE.FC],TYPE.FC.supports,[1,2,3]));
  
  GNUplot histogram = GNUplot(gnudata2,["Histogram"],[TYPE.H]);
  histogram.addCmd("set yrange [0:*]");
  gnuoutput.plot(histogram);
//  gnudata2.cleanup();
}
