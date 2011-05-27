dmd -c -l types.D support.D LUdecomposition.D regression.D
dmd main.D types.lib phobos.lib