/******************************************************************//**
 * \file src/gui/formats/an8types.d
 * \brief AN8 type definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.formats.an8types;

import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;

import core.typedefs.types;

enum An8SphereType{LONGLAT, GEODESIC}

/*! \brief Anim8tor chunk
 *
 *  Representation of an anim8tor chunk
 */
struct An8Chunk{
  string     name;
  int        start;
  int        end;
  string     content;
  An8Chunk[] subchunks;
}

/*! \brief Anim8tor file
 *
 *  Representation of an anim8tor file
 */
struct An8{
  string     filename;
  FileStatus status;
  string     filecontent;
  An8Chunk[] chunks;
  Figure[]   figures;
}

/*! \brief Anim8tor cylinder
 *
 *  Representation of an anim8tor cylinder
 */
struct An8Cylinder{
  string material = " -- default --";
  int    lon =12;
  int    lat = 8;
  float  diameter = 1;
  float  topdiameter = 1;
  float  length;
  bool   startcap,endcap;
}

/*! \brief Anim8tor sphere
 *
 *  Representation of an anim8tor sphere
 */
struct An8Sphere{
  string         material = " -- default --";
  float          diameter = 1;
  int            lon      = 12;
  int            lat      = 8;
  An8SphereType  type     = An8SphereType.LONGLAT;
}

/*! \brief Anim8tor cube
 *
 *  Representation of an anim8tor cube
 */
struct An8Cube{
  string material = " -- default --";
  int    x=10;
  int    y=10;
  int    z=10;
  int    xdiv=1;
  int    ydiv=1;
  int    zdiv=1;
}
