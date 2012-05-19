Installation
------------
Download and install DMD for D language 2.0+ (http://dlang.org/download.html), 
also get Ruby 1.9.1 (or higher) preferably with GEM (http://www.ruby-lang.org/) and 
install Rake (http://rake.rubyforge.org/). Some libraries and/or examples require 
external libraries:

- (Optional for GUI) Download and install SDL for your platform (http://www.libsdl.org/)
- (R for Statistics) Download and install R for your platform (http://www.r-project.org/)
- (Aligner) Download and install BLAST (ftp://ftp.ncbi.nlm.nih.gov/blast/)
- (GNUplot) Download and install GNUplot (http://www.gnuplot.info/download.html)

Dependencies
------------
Under Linux run, switch to super user and install the following packages:

    $ apt-get install r-base liblapack-dev libblas-dev 
    $ apt-get install libsdl1.2-dev libopenal-dev libalut-dev libsdl-image1.2-dev

When using Windows put the 32bit DLLs on your PATH by executing the provided .bat file:

    $ cd <install-location>/D-coding
    $ DLLonPATH.bat

Compilation
-----------
Compile using rake and dmd on your %PATH%:

    $ rake -T         # List all possible build and test options
    $ rake app:<name> # Build single standalone application
    $ rake build      # Build all applications
    $ rake unittest   # Run the unit tests

Applications
------------
The provided applications are itself are not that interesting, and sometimes far from finished, 
however here a short description on what they are supposed to do:

    - actor : Testing D2.0 actors
    - aligner: Performs blastn on raw DNA sequences to a whole genome sequences in a fasta file
    - correlation: Calculate correlation between vectors
    - csc : Caesar subsitution cipher in ASM
    - dnacode: Translates an input sequence in DNA to Anti, mRNA and possible proteins
    - GNUplot: Use GNUplot to visualize data from D2.0 vector and matrix objects 
    - gameserver: Basic gameserver using a custom protocol
    - sdl: OS independent SDL OpenGL platform for testing D <-> SDL <-> OpenGL bindings
    - ostest: Testing operating system cmdline functionality
    - plang: Implementation of a P'' interpreter
    - regression: Multiple regression adapted from MQM routine
    - fileloader: High speed big data file loading using the D language
    - httpreader: Basic HTTP slurper
    - httpserver: Basic try at a HTTP server

To build an application simply run:

```
    $ rake app:aligner
    $ rake app:correlation
    $ rake app:csc
    $ rake app:dnacode
    $ rake app:ostest
    $ rake app:plang
    $ rake app:startJVM
    $ rake app:regression
    $ rake app:correlation
    $ rake app:gameserver
    $ rake app:sdl
```

Want to contribute? Great!
------------

1. Clone it.
2. Compile it.
3. Run it.
4. Modify some code. (Search -> 'TODO')
5. Go back to 2, or
6. Submit a patch

You can also just post comments on code / commits.
Danny Arends

Disclaimer
----------
This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License,
version 3, as published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.  See the GNU
General Public License, version 3, for more details.

A copy of the GNU General Public License, version 3, is available
at [http://www.r-project.org/Licenses/GPL-3](http://www.r-project.org/Licenses/GPL-3 "GPL-3 Licence")

Copyright (c) 2012 [Danny Arends](http://www.dannyarends.nl)
