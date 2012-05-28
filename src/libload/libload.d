/******************************************************************//**
 * \file src/libload/libload.d
 * \brief Shared library loader
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module libload.libload;

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
  const string sh_lib_ext = ".dll";
  const string st_lib_ext = ".lib";
}else version(linux){
  const string sh_lib_ext = ".so";
  const string st_lib_ext = ".a";
}else version(darwin){
  const string sh_lib_ext = ".dylib";
  const string st_lib_ext = ".a";
}

/*
 * Loads a single shared library (dll, so, dylib)
 */
protected HXModule load_library(string win_name, string linux_name = "", string osx_name = "", bool extension=true){
  HXModule shared_library = null;
  if(linux_name == "") linux_name = win_name;
  if(osx_name == "") osx_name = win_name;	
  version(Windows){
    string full_name = win_name ~ sh_lib_ext;
  }else version(linux){
    string full_name = "lib" ~ linux_name;
    if(extension) full_name = full_name ~ sh_lib_ext;
  }else version(darwin){
    string full_name = "/usr/lib/"~ osx_name;
    if(extension) full_name = full_name ~ sh_lib_ext;
  }
  if((shared_library = ExeModule_Load(full_name)) is null){
    throw new Exception("[LIB] Unable to find shared library: " ~ full_name);
  }
  debug writeln("[LIB] Loaded shared library: " ~ full_name);
  return shared_library;
}

/*
 * Adds the operator call to load_function(T)(lib, name)
 */
package struct function_binding(T) {
  bool opCall(HXModule lib, string name) {
    try{
      *fptr = getFunctionThroughVoid(lib, name);
      debug writeln("[LIB] Loaded shared function: " ~ name);
      return true;
    }catch(Exception e){
      writeln("[LIB] Cannot bind function: " ~ name);
      return false;
    }
  }

  private:
    void** fptr;
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
