/**
 * \file libLoad.d - Shared library loader
 * Description: Shared c and cpp library loader for the D language
 *
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - pure: load_function, load_function
 * - private: getFunctionThroughVoid, load_library
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module core.libload.libload;

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

version(Windows){
  const string extension = ".dll";
}else version(linux){
  const string extension = ".so";
}else version(darwin){
  const string extension = ".dylib";
}


/*
 * Loads a single shared library (dll, so, dylib)
 */
protected HXModule load_library(string win_name, string linux_name = "", string osx_name = ""){
  HXModule shared_library = null;
  if(linux_name == "") linux_name = win_name;
  if(osx_name == "") osx_name = win_name;	
	version(Windows){
		shared_library = ExeModule_Load(win_name ~ extension);
	}else version(linux){
		shared_library = ExeModule_Load("lib" ~ linux_name ~ extension);
	}else version(darwin){
		shared_library = ExeModule_Load("/usr/lib/"~ osx_name ~ extension);
	}
  if(shared_library is null){
	throw new Exception("Unable to find shared library: " ~ win_name ~ ", " ~ linux_name);
  }
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
