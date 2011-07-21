/**
 * \file kernel.d - Wrapper for kernel32.dll
 * 
 * Description: 
 *   Wrapper for kernel32.dll
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

module win.kernel;

//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import win.wintypes;

extern(Windows){
  HMODULE function(char* name) LoadLibraryA;
  FARPROC function(HMODULE hm, char* name) GetProcAddress;
  void function(HMODULE hm) FreeLibrary;
  DWORD function() GetLastError;
  DWORD function(DWORD, LPCVOID, DWORD, DWORD, LPCSTR, DWORD, VA_LIST*) FormatMessageA;
  HLOCAL function(HLOCAL) LocalFree;
}

static this(){
  HXModule lib = load_library("kernel32");
  load_function(LoadLibraryA)(lib,"LoadLibraryA");
  load_function(GetProcAddress)(lib,"GetProcAddress");
  load_function(FreeLibrary)(lib,"FreeLibrary");
  load_function(GetLastError)(lib,"GetLastError");
  load_function(FormatMessageA)(lib,"FormatMessageA");
  load_function(LocalFree)(lib,"LocalFree");
  writeln("Loaded Win32 KERNEL functionality");
}