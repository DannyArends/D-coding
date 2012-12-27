/******************************************************************//**
 * \file deps/gl/glu.d
 * \brief Wrapper for GLUT
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written 2010<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module opengl.glu;

import std.stdio, std.conv, std.c.stdarg;
import libload.loader, libload.libload;
import opengl.gl_1_0, opengl.gl_1_1;

static this(){
  HXModule lib = load_library("glu32","GLU","");
  load_function(gluGetString)(lib,"gluGetString");
  load_function(gluLookAt)(lib,"gluLookAt");
  load_function(gluOrtho2D)(lib,"gluOrtho2D");
  load_function(gluPerspective)(lib,"gluPerspective");
  load_function(gluPickMatrix)(lib,"gluPickMatrix");
  load_function(gluProject)(lib,"gluProject");
  load_function(gluUnProject)(lib,"gluUnProject");
  debug writeln("[ D ] Mapped GLU functionality");
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

