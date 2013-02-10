module dcode.errors;

import std.c.stdlib : exit;
import std.stdio    : stderr, writeln, writefln;
import std.string   : xformat;

/* Write an warning string to stdout */
void warning(in string s){
  writeln();
  writefln("-Warning: %s\n", s);
}

/* Write an error string to stderr */
void error(in string s){
  stderr.writeln();
  stderr.writefln("-Error: %s\n", s);
}

/* Abort with error code, default: -1 */
void abort(in string s, int exitcode = -1){
  error(s);
  exit(exitcode);
}

/* Abort because an expectation isn't satisfied (-2) */
void expected(in string s, in string o){
  abort(xformat("'%s' expected, but found: '%s'", s, o), -2);
}

/* Abort because an identifier is undefined (-3) */
void undefined(in string name){
  abort(xformat("Undefined identifier: %s", name), -3);
}

/* Abort because an identifier is duplicated (-4) */
void duplicate(in string name){
  abort(xformat("Duplicate identifier: %s", name), -4);
}

