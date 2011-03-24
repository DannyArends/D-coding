dmd -c -lib dpart.d
dmc -c cpart.c
dmd cpart.obj dpart.lib phobos.lib