module dcode.io.reader;

import std.stdio, std.file, std.conv;

enum BUFFER{ 
  S16KB  =      16_384, 
  S2MB   =   2_097_152, 
  S4MB   =   4_194_304, 
  S16MB  =  16_777_216, 
  S64MB  =  67_108_864, 
  S256MB = 268_435_456
}

abstract class Reader{
  @property BUFFER buffersize(){ return _bsize; }
  @property void   buffersize(BUFFER size){ _bsize = size; }
  abstract T[]     readAsVector(T)(string filename, char sep = '\n');
  abstract T[][]   readAsMatrix(T)(string filename, char[2] seps = ['\t','\n']);

  protected:
    BUFFER _bsize = BUFFER.S2MB;
}

