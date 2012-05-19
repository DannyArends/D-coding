GNU plotting for D 2.0
----------------------
Download and install [GNUplot](http://www.gnuplot.info/download.html) and the 
[DMD 2.0 Compiler](http://www.digitalmars.com/d/download.html). Don't forget 
to put both executables on your %PATH%. Then in your D 2.0 source code prepare 
your data as a Vector or Matrix, and import the GNUplot libraries:

```D
    import core.array.matrix; // Basic matrix operations
    import gnu.gnuaux, gnu.data, gnu.output, gnu.plot;
    
    float[][] your_matrix;  // Or: int[][], float[][], double[][], char[][]
    float[]   your_vector;  // Or: int[], float[], double[], char[]
```

Convert to GNUdata container

```D
    auto gnudata = new GNUdata!float(your_matrix);
```

Setup the GNUoutput device and create a GNUplot object

```D
    GNUout plotwindow = TERMINAL.PNG; // Or: EPS/GIF/JPG/PNG/PS/SVG/SVGI
    auto gnuoutput    = GNUoutput(plotwindow);
    auto gnuplot      = GNUplot(gnudata);
```
 
Create different plots

```D
    gnuoutput.plot(gnuplot);   //Line plot
    gnuoutput.splot(gnuplot);  //3D perspective plot
    gnuoutput.image(gnuplot);  //Heatmap
```

<img src="https://github.com/DannyArends/D-coding/raw/master/data/gnuplot/ex_m_qtl_2.png" width="256px" height="192px"/>
<img src="https://github.com/DannyArends/D-coding/raw/master/data/gnuplot/ex_heatmap_2.png" width="256px" height="192px"/>
<img src="https://github.com/DannyArends/D-coding/raw/master/data/gnuplot/ex_m_qtl_1.png" width="256px" height="192px"/>

More examples
-------------

See the examples: [HERE](https://github.com/DannyArends/D-coding/tree/master/src/gnuplot/examples#examples-gnuplot-for-d)

Disclaimer
----------
Copyright (c) 2012 [Danny Arends](http://www.dannyarends.nl)
