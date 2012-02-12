module gui.formats.an8types;

import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;

import core.typedefs.types;

enum An8SphereType{LONGLAT, GEODESIC}

struct An8Chunk{
  string     name;
  int        start;
  int        end;
  string     content;
  An8Chunk[] subchunks;
}

struct An8{
  string     filename;
  FileStatus status;
  string     filecontent;
  An8Chunk[] chunks;
  Figure[]   figures;
}

struct An8Cylinder{
  string material = " -- default --";
  int    lon =12;
  int    lat = 8;
  float  diameter = 1;
  float  topdiameter = 1;
  float  length;
  bool   startcap,endcap;
}

struct An8Sphere{
  string         material = " -- default --";
  float          diameter = 1;
  int            lon      = 12;
  int            lat      = 8;
  An8SphereType  type     = An8SphereType.LONGLAT;
}

struct An8Cube{
  string material = " -- default --";
  int    x=10;
  int    y=10;
  int    z=10;
  int    xdiv=1;
  int    ydiv=1;
  int    zdiv=1;
}
