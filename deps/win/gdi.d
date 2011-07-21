/**
 * \file gdi.d - Wrapper for gdi32.dll
 * Description: Wrapper for GDI under Win32
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module win.gdi;

//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import win.wintypes;
 
extern(Windows){
  /* HDC functions */
  int function(HDC,PIXELFORMATDESCRIPTOR*) ChoosePixelFormat;
  BOOL function(HDC) SwapBuffers;
  int function(HDC) GetPixelFormat;
  int function(HDC,int,UINT,PIXELFORMATDESCRIPTOR*) DescribePixelFormat;
}

static this(){
  HXModule lib = load_library("gdi32");

  load_function(ChoosePixelFormat)(lib,"ChoosePixelFormat");
  load_function(GetPixelFormat)(lib,"GetPixelFormat");
  load_function(DescribePixelFormat)(lib,"DescribePixelFormat");
  load_function(SwapBuffers)(lib,"SwapBuffers");
  writeln("Loaded Win32 GDI functionality");
}
