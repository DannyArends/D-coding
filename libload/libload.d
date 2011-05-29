module libload.libload;
//============================================================================
// libLoad.d - Shared library loader
//
// Description: 
//   Shared c and cpp library loader for the D language
//
// Version: 0.1
// Contributors: Danny Arends
// Written in the D Programming Language (http://www.digitalmars.com/d)
//============================================================================
private import std.loader;
private import std.stdio;
private import std.conv;

/*
 * Gets a function void* from a HXModule and functionname 
 */
private void* getFunctionThroughVoid(HXModule shared_library, string functionname){
	void* symbol = ExeModule_GetSymbol(shared_library, functionname);
	if (symbol is null) {
		writeln("Failed to load function address " ~ functionname);
	}
	return symbol;
}

/*
 * Loads a single shared library (dll, so, dylib)
 */
HXModule load_library(string library_prefix){
  HXModule shared_library = null;
	version (Windows) {
		shared_library = ExeModule_Load(library_prefix ~ ".dll");
	} else version (linux) {
		shared_library = ExeModule_Load(library_prefix ~ ".so");
	} else version (darwin) {
		shared_library = ExeModule_Load("/usr/lib/"~ library_prefix ~".dylib");
	}
  if(shared_library is null){
    writeln("Unable to find shared library: " ~ library_prefix);
    return null;
  }else{
    debug writeln("Loaded shared library: " ~ library_prefix);
    return shared_library;
  }
}

/*
 * Loads a single function (Opens the library_prefix file)
 */
T load_function(T)(string library_prefix, string functionname) {
  HXModule shared_library = load_library(library_prefix);
  T returnfunction = load_function!T(shared_library, functionname);
  debug writeln(functionname ~" function mapped from " ~ library_prefix);
	return returnfunction;
}

/*
 * Loads a single function (Needs a live reference to the library)
 */
T load_function(T)(HXModule shared_library, string functionname) {
  return (cast(T) getFunctionThroughVoid(shared_library, functionname));
}
