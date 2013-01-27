import std.stdio, std.conv, std.file, std.utf;
import ext.opengl.gl, ext.sdl.sdl;

struct Map{
  int    x,y;
  string data[float][float][float];
}

