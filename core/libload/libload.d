/**
 * \file libLoad.d - Shared library loader
 * 
 * Description: 
 *   Shared c and cpp library loader for the D language
 *
 * Copyright (c) 2010 Danny Arends
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
 * - pure: load_function, load_function
 * - private: getFunctionThroughVoid, load_library
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
module core.libload.libload;
//D 2.0 std imports
private import std.loader;
private import std.stdio;
private import std.conv;

/*
 * Gets a function void* from a HXModule and functionname 
 */
protected void* getFunctionThroughVoid(HXModule shared_library, string functionname){
	void* symbol = ExeModule_GetSymbol(shared_library, functionname);
	if (symbol is null) throw new Exception("Failed to load function address " ~ functionname);
	return symbol;
}

/*
 * Loads a single shared library (dll, so, dylib)
 */
protected HXModule load_library(string library_prefix){
  HXModule shared_library = null;
	version (Windows) {
		shared_library = ExeModule_Load(library_prefix ~ ".dll");
	} else version (linux) {
		shared_library = ExeModule_Load(library_prefix ~ ".so");
	} else version (darwin) {
		shared_library = ExeModule_Load("/usr/lib/"~ library_prefix ~".dylib");
	}
  if(shared_library is null) throw new Exception("Unable to find shared library: " ~ library_prefix);
  debug writeln("Loaded shared library: " ~ library_prefix);
  return shared_library;
}

/*
 * Adds the operator call to load_function(T)(lib, name)
 */
package struct function_binding(T) {
  bool opCall(HXModule lib, string name) {
    try{
      *fptr = getFunctionThroughVoid(lib, name);
      return true;
    }catch(Exception e){
      writeln("Cannot bind function: " ~ name);
      return false;
    }
  }

  private{
    void** fptr;
  }
}

/*
 * Loads a single function (Needs a live reference to the library)
 */
template load_function(T){
  function_binding!(T) load_function(ref T a) {
    function_binding!(T) res;
    res.fptr = cast(void**)&a;
    return res;
  }
}
