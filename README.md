Installation
------------
- Download and install DMD for D language 2.0+ (http://www.d-programming-language.org/)
- Download and install Ruby 1.9.1 (or higher) preferably with GEM (http://www.ruby-lang.org/)
- Install Rake (http://rake.rubyforge.org/)

Some libraries and/or examples require external libraries:

- (Optional for GUI) Download and install GTK for your platform (http://www.gtk.org/)
- (R for Statistical) Download and install R for your platform (http://www.r-project.org/)
- (Additional for Win32) Download and install DFL (http://www.dprogramming.com/dfl.php)

Compile with using rake, dmd (and optionally dfl) on %PATH%:
List all possible build and test options:

    $ rake -T

Build all examples and standalone LIB components:

    $ rake build

Building only the standalone LIB components for re-use:

    $ rake libs

Applications
------------
The provided applications are itself are not that interesting, and sometimes far from finished, 
however here a short description on what they are supposed to do is provided:

- Plang: implementation of a p'' interpreter
- Regression: Multiple regression adapted from MQM routine
- Fileloader: High speed big data file loading using the D language
- Fastamaker: performs blastn on raw DNA sequences in a file to sequences in a fasta file (you'll need: ftp://ftp.ncbi.nlm.nih.gov/blast/executables/LATEST/)
- Httpreader: Basic HTTP slurper
- Httpserver: Basic try at a HTTP server
- Httpserver: Basic try at a HTTP server
- DNAcode: Translates an input sequence in DNA to Anti, mRNA and possible proteins


Deprecated things, which I like to replace by the new direct GTK->GL bindings:

- Dflapplication: First test in DFL
- Dfltreeexample: Directory browsing plug-in for DFL
- Dflopengl: OpenGL test application in D supporting 3DS model and TGA texture loading

------------

Want to contribute? Great!

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
Copyright (c) 2010 Danny Arends
