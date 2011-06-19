Installation
------------
- Download and install DMD for D language 2.0+
- (Optional for GUI) Download and install DFL

Compile with using dmd (and dfl) on %PATH%:

Applications
------------
The applications itself are not that intresting, a short description:

- Regression: Multiple regression adapted from MQM routine
- Fileloader: High speed big data file loading using the D language
- Httpreader: Basic HTTP slurper
- Httpserver: Basic try at a HTTP server
- Dflapplication: First test in DFL
- Dfltreeexample: Directory browsing plugin for DFL
- Dflopengl: OpenGL test application in D supporting 3DS model and TGA texture loading

Re-usable components
------------
Standalone LIB components for re-use

    $ dmd -run cdc.d -lib src/core -ofCore.lib
    
Plugin library examples: Gui.lib depends on openGL, Regression.lib depends on Core and R (in deps)
    
    $ dmd -run cdc.d -dfl -lib src/gui src/core -ofGui.lib -Ideps
    $ dmd -run cdc.d -lib src/plugins/regression src/core -ofRegression.lib -Ideps/

Two ways of compile a single application are available: (1) Full compile, (2) Using a previously build library

    $ dmd -run cdc.d src/fileloader.d src/core                 #File loading test, Full compile
    $ dmd -run cdc.d src/fileloader.d Core.lib -Isrc/          #Or versus the library (Note: include of src/)
    $ fileloader.exe
    
    $ dmd -run cdc.d src/httpreader.d src/core                 #Httpreader, Full compile
    $ httpreader  www.dannyarends.nl 80 /
    
    $ dmd -run cdc.d -dfl src/dflapplication.d Gui.lib -Isrc/  #GUI example DFL, depends on Gui.lib
    $ dflapplication.exe
    
We can map external libraries e.g. R.dll, Windows (GDI32.dll + Kernel.dll), OpenGL32.dll using Core.lib

    $ dmd -run cdc.d -lib deps/r Core.lib -ofR.lib -Isrc/
    $ dmd -run cdc.d -lib deps/win Core.lib -ofWindows.lib -Isrc/
    $ dmd -run cdc.d -lib deps/gl Core.lib -ofOpenGL.lib -Ideps -Isrc/
    
Building bigger applications is made possible by mixing and matching the parts that we want and putting them together using a 
single arc/main.d file in the src/ folder. Here we link the multiple regression application using Core.lib, Regression.lib and R.lib

    $ dmd -run cdc.d src/regression.d Core.lib R.lib Regression.lib -Isrc/ -Ideps/
    $ regression.exe

Or when lazy just let the linker figure out which parts we need, unfortunately then the linker links all DLLs referenced 
from deps to be loaded at application startup. This is why src/core file are NOT allowed to load libraries, only src/plugins and 
src/gui files are allowed to include from the deps/ dir (and as such map external SO/DLL files).

    $ dmd -run cdc.d src/regression.d src/core src/plugins deps/
    $ regression.exe

Another example is a D application that uses OpenGL in the GUI context, basically we link versus many libraries (Gui.lib, 
OpenGL.lib and Windows.lib). Compile the libraries first (see above) and the build the application,

    $ dmd -run cdc.d -dfl src/dflopengl.d Gui.lib OpenGL.lib Windows.lib Core.lib -Ideps
    $ dflopengl.exe

Or let the linker figure it out (Note: loads all needed DLLs at startup)

    $ dmd -run cdc.d -dfl src/dflopengl.d src/core src/gui deps/
    $ dflopengl.exe

Contributing
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
