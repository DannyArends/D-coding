/**
 * \file gdi.d - Wrapper for gdi32.dll
 * 
 * Description: 
 *   Wrapper for gdi32.dll
 *
 * Copyright (c) 2010 Danny Arends
 *
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
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
  writeln("mapped gdi32.dll");
}
