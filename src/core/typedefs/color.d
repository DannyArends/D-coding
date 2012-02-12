/**********************************************************************
 * \file src/core/typedefs/color.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written 2010
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.color;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import core.memory;

struct Color {
  ubyte r;
  ubyte g;
  ubyte b;
  ubyte a;

  this(int red, int green, int blue, int alpha = 255) {
    this.r = cast(ubyte) red;
    this.g = cast(ubyte) green;
    this.b = cast(ubyte) blue;
    this.a = cast(ubyte) alpha;
  }
  
  this(int[] color){
    this.r = cast(ubyte) color[0];
    this.g = cast(ubyte) color[1];
    this.b = cast(ubyte) color[2];
    this.a = cast(ubyte) color[3];
  }

  static Color transparent(){ return Color(0, 0, 0, 0); }
  static Color white(){ return Color(255, 255, 255); }
  static Color black(){ return Color(0, 0, 0); }
  
  string toString(){
    return to!string(r) ~ "," ~ to!string(g) ~"," ~ to!string(b) ~"," ~ to!string(a) ~ "\t";
  }
}

Color fromHsl(real h, real s, real l) {
  h = h % 360;
  real C = (1 - abs(2 * l - 1)) * s;
  real hPrime = h / 60;
  real X = C * (1 - abs(hPrime % 2 - 1));
  real r, g, b;

  if(std.math.isNaN(h)){
    r = g = b = 0;
  }else if (hPrime >= 0 && hPrime < 1) {
    r = C;
    g = X;
    b = 0;
  } else if (hPrime >= 1 && hPrime < 2) {
    r = X;
    g = C;
    b = 0;
  } else if (hPrime >= 2 && hPrime < 3) {
    r = 0;
    g = C;
    b = X;
  } else if (hPrime >= 3 && hPrime < 4) {
    r = 0;
    g = X;
    b = C;
  } else if (hPrime >= 4 && hPrime < 5) {
    r = X;
    g = 0;
    b = C;
  } else if (hPrime >= 5 && hPrime < 6) {
    r = C;
    g = 0;
    b = X;
  }
  real m = l - C / 2;
  r += m;
  g += m;
  b += m;
  return Color(cast(ubyte)(r * 255),cast(ubyte)(g * 255),cast(ubyte)(b * 255),255);
}
