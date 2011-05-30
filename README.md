Some practice in D
=================

Installation
------------
- Download and install DMD for D language 2.0+
- (Optional for GUI) Download and install DFL

Compile with using dmd (and dfl) on %PATH%:
    
    #Pure Components
    $ dmd -run cdc.d -lib core -ofCore.lib -Icore -Ideps  #Core: Depends on itself and deps
    
    #Single application
    $ dmd -run cdc.d app/fileloader -Icore                #Exp:     XBinary
    $ dmd -run cdc.d -dfl app/dflapplication.d            #GUI:     DFL
    
    #External libraries (against Core.lib)
    $ dmd -run cdc.d -lib deps/r Core.lib -ofR.lib -Icore
    
    #D application linked versus Core.lib and R.DLL
    $ dmd -run cdc.d app/regression.d Core.lib R.lib -Icore -Ideps

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
