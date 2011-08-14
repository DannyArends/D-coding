module core.typedefs.basictypes;

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

  static Color transparent() {
    return Color(0, 0, 0, 0);
  }

  static Color white() {
    return Color(255, 255, 255);
  }

  static Color black() {
    return Color(0, 0, 0);
  }
  
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

/*
 * Transforms a character to its value when SHIFT is pressed
 * Based on US-101 keyboard
 */
char toShiftChar(char c){
  if(isNumeric(c)){
    switch(to!int(to!string(c))){
      case 0:
        return ')';
      break;
      case 1:
        return '!';
      break;
      case 2:
        return '@';
      break;
      case 3:
        return '#';
      break;      
      case 4:
        return '$';
      break;
      case 5:
        return '%';
      break;
      case 6:
        return '^';
      break;
      case 7:
        return '&';
      break;
      case 8:
        return '*';
      break;
      case 9:
        return '(';
      break;
      default:
      break;
    }
  }
  return to!char(toUpper(to!string(c)));
}

/*
 * Splits a string by sep, and transforms each element to types of T
 */
T[] stringToArray(T)(string s, string sep= ","){
  string[] entities = s.split(sep);
  T[] marray;
  foreach(string e;entities){
    marray ~= to!T(e);
  }
  return marray;
}

struct Point {
  int x;
  int y;
}

struct Size {
  int width;
  int height;
}