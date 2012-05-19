import std.stdio, std.string, std.conv, std.math, std.file;
import examples.ex_lineplot;
import examples.ex_heatmap;
import examples.ex_multiple_qtl_plots;

void main(string[] args){
  writeln("[DGNUplot] Running all examples");
  ex_lineplot();
  ex_heatmap();
  ex_multiple_qtl_plots();
  writeln("[DGNUplot] Examples done");
}
