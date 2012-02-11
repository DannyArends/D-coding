/**********************************************************************
 * \file deps/gl/glu.d - Wrapper for GLUT
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/ 

module gl.glu;

import std.loader;
import std.stdio;
import std.conv;
import std.c.stdarg;

private import gl.gl_1_0;
private import gl.gl_1_1;

import libload.libload;

static this(){
  HXModule lib = load_library("glu32","GLU","");
  load_function(gluGetString)(lib,"gluGetString");
  load_function(gluLookAt)(lib,"gluLookAt");
  load_function(gluOrtho2D)(lib,"gluOrtho2D");
  load_function(gluPerspective)(lib,"gluPerspective");
  load_function(gluPickMatrix)(lib,"gluPickMatrix");
  load_function(gluProject)(lib,"gluProject");
  load_function(gluUnProject)(lib,"gluUnProject");
  writeln("Mapped GLU functionality");
}

//==============================================================================
// CONSTANTS
//==============================================================================
enum : GLenum{
  GLU_FALSE                       = 0,
  GLU_TRUE                        = 1,
  // StringName
  GLU_VERSION                     = 100800,
  GLU_EXTENSIONS                  = 100801,
}

extern(System){
	GLubyte* function(GLenum) gluGetString;
	void function(GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble,GLdouble) gluLookAt;
	void function(GLdouble,GLdouble,GLdouble,GLdouble) gluOrtho2D;
	void function(GLdouble,GLdouble,GLdouble,GLdouble) gluPerspective;
	void function(GLdouble,GLdouble,GLdouble,GLdouble,GLint*) gluPickMatrix;
	GLint function(GLdouble,GLdouble,GLdouble,GLdouble*,GLdouble*,GLint*,GLdouble*,GLdouble*,GLdouble*) gluProject;
	GLint function(GLdouble,GLdouble,GLdouble,GLdouble*,GLdouble*,GLint*,GLdouble*,GLdouble*,GLdouble*) gluUnProject;
}
