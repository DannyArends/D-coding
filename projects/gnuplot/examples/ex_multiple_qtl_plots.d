module examples.ex_multiple_qtl_plots;

import std.stdio, std.string, std.conv, std.math, std.file;
import gnuplot.gnuaux, gnuplot.data, gnuplot.output, gnuplot.plot;

void ex_multiple_qtl_plots(){
  float[][] datamatrix = parseCSV!float("data/example/qtls.txt");
  auto gnudata = new GNUdata!float(datamatrix);
  // Select output
  GNUout plotwindow = TERMINAL.PNG;
  
  string[] stubnames;
  for(size_t x = 1; x <= gnudata.rows(); x++){
    stubnames ~= ("Trait " ~ to!string(x));
  }
  // Setup the gnuoutput on the output
  auto gnuoutput = GNUoutput(plotwindow,"<Plot Title>",["Marker","LOD","Trait"]);

  // Setup a plot using the gnudata
  auto gnuplot = GNUplot(gnudata,stubnames);

  // Send to plot to the GNUoutput device
  gnuoutput.title   = "QTL line plot";
  gnuoutput.legend  = true;
  gnuoutput.plot(gnuplot,[1,6]); // Plot only the first 5
  
  gnuoutput.labels  = ["Marker", "Trait", "LOD"];
  gnuoutput.title   = "3D perspective plot";
  gnuoutput.legend  = false;
  gnuoutput.splot(gnuplot);
  
  gnuoutput.title = "Filled 3D perspective plot";
  gnuoutput.splot(gnuplot, true);

  gnuplot.p_rgb = [23,28,3];  
  gnuoutput.title = "QTL heatmap";
  gnuoutput.image(gnuplot);
  
  gnudata.cleanup();
}
