Some practice in D
=================

Installation
------------
- Download and install DMD for D language 2.0+
- (Optional for GUI) Download and install DFL

Compile with using dmd (and dfl) on %PATH%:
    
    #Pure Components
    $ dmd -run cdc.d -lib core -ofCore.lib -Ideps       #Core: Depends on itself and deps
    $ dmd -run cdc.d -dfl -lib gui -ofGui.lib -Ideps    #GUI: Depends on core and deps
    
    #Single application
    $ dmd -run cdc.d app/fileloader.d Core.lib              #File loading test, depends Core.lib
    $ fileloader.exe
    $ dmd -run cdc.d app/httpreader.d Core.lib              #Httpreader test, depends Core.lib
    $ httpreader  www.dannyarends.nl 80 /
    $ dmd -run cdc.d -dfl app/dflapplication.d Gui.lib      #GUI: DFL, depends on Gui.lib
    $ dflapplication.exe
    
We can map external libraries e.g. R.dll, Windows (GDI32.dll + Kernel.dll), OpenGL32.dll using Core.lib

    $ dmd -run cdc.d -lib deps/r Core.lib -ofR.lib
    $ dmd -run cdc.d -lib deps/win Core.lib -ofWindows.lib
    $ dmd -run cdc.d -lib deps/gl Core.lib -ofOpenGL.lib -Ideps
    
Building bigger applications by mixing and matching the parts that we want and put em together using a 
single app/main.d
    
    #Mix and match D applications e.g. link versus Core.lib and R.lib
    $ dmd -run cdc.d app/regression.d Core.lib R.lib -Ideps
    $ regression.exe
    
    #D application linked versus Gui.lib, OpenGL.lib and Windows.lib
    $ dmd -run cdc.d -dfl app/dflopengl.d Gui.lib OpenGL.lib Windows.lib Core.lib -Ideps
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
