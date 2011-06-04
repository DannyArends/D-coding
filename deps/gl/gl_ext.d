module gl.gl_ext;

import std.loader;
import std.stdio;
import std.conv;
import std.c.stdarg;

private import gl.gl_1_0;

import core.libload.libload;

private bool arb_buffer_enabled = false;

static bool isArbBufferEnabled(){
  return arb_buffer_enabled;
}

//Load the functions when the module is loaded
static this(){
  HXModule lib = load_library("opengl32");
  // gl 1.1
  if(!load_function(glBindBufferARB)(lib, "glBindBufferARB")) arb_buffer_enabled=false;
  if(!load_function(glDeleteBuffersARB)(lib, "glDeleteBuffersARB")) arb_buffer_enabled=false;
  if(!load_function(glGenBuffersARB)(lib, "glGenBuffersARB")) arb_buffer_enabled=false;
  if(!load_function(glIsBufferARB)(lib, "glIsBufferARB")) arb_buffer_enabled=false;
  if(!load_function(glBufferDataARB)(lib, "glBufferDataARB")) arb_buffer_enabled=false;
  if(!load_function(glBufferSubDataARB)(lib, "glBufferSubDataARB")) arb_buffer_enabled=false;
  if(!load_function(glMapBufferARB)(lib, "glMapBufferARB")) arb_buffer_enabled=false;
  if(!load_function(glUnmapBufferARB)(lib, "glUnmapBufferARB")) arb_buffer_enabled=false;
  if(!load_function(glGetBufferParameterivARB)(lib, "glGetBufferParameterivARB")) arb_buffer_enabled=false;
  if(!load_function(glGetBufferPointervARB)(lib, "glGetBufferPointervARB")) arb_buffer_enabled=false;
  arb_buffer_enabled=true;
  writeln("Mapped ARB buffers");
}

alias ptrdiff_t GLintptrARB;
alias ptrdiff_t GLsizeiptrARB;

enum : GLenum{
    GL_BUFFER_SIZE_ARB                             = 0x8764,
    GL_BUFFER_USAGE_ARB                            = 0x8765,
    GL_ARRAY_BUFFER_ARB                            = 0x8892,
    GL_ELEMENT_ARRAY_BUFFER_ARB                    = 0x8893,
    GL_ARRAY_BUFFER_BINDING_ARB                    = 0x8894,
    GL_ELEMENT_ARRAY_BUFFER_BINDING_ARB            = 0x8895,
    GL_VERTEX_ARRAY_BUFFER_BINDING_ARB             = 0x8896,
    GL_NORMAL_ARRAY_BUFFER_BINDING_ARB             = 0x8897,
    GL_COLOR_ARRAY_BUFFER_BINDING_ARB              = 0x8898,
    GL_INDEX_ARRAY_BUFFER_BINDING_ARB              = 0x8899,
    GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING_ARB      = 0x889A,
    GL_EDGE_FLAG_ARRAY_BUFFER_BINDING_ARB          = 0x889B,
    GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING_ARB    = 0x889C,
    GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING_ARB     = 0x889D,
    GL_WEIGHT_ARRAY_BUFFER_BINDING_ARB             = 0x889E,
    GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING_ARB      = 0x889F,
    GL_READ_ONLY_ARB                               = 0x88B8,
    GL_WRITE_ONLY_ARB                              = 0x88B9,
    GL_READ_WRITE_ARB                              = 0x88BA,
    GL_BUFFER_ACCESS_ARB                           = 0x88BB,
    GL_BUFFER_MAPPED_ARB                           = 0x88BC,
    GL_BUFFER_MAP_POINTER_ARB                      = 0x88BD,
    GL_STREAM_DRAW_ARB                             = 0x88E0,
    GL_STREAM_READ_ARB                             = 0x88E1,
    GL_STREAM_COPY_ARB                             = 0x88E2,
    GL_STATIC_DRAW_ARB                             = 0x88E4,
    GL_STATIC_READ_ARB                             = 0x88E5,
    GL_STATIC_COPY_ARB                             = 0x88E6,
    GL_DYNAMIC_DRAW_ARB                            = 0x88E8,
    GL_DYNAMIC_READ_ARB                            = 0x88E9,
    GL_DYNAMIC_COPY_ARB                            = 0x88EA,
}

extern(System){
  void function(GLenum, GLuint) glBindBufferARB;
  void function(GLsizei, GLuint*) glDeleteBuffersARB;
  void function(GLsizei, GLuint*) glGenBuffersARB;
  GLboolean function(GLuint) glIsBufferARB;
  void function(GLenum, GLsizeiptrARB, GLvoid*, GLenum) glBufferDataARB;
  void function(GLenum, GLintptrARB, GLsizeiptrARB, GLvoid*) glBufferSubDataARB;
  void function(GLenum, GLintptrARB, GLsizeiptrARB, GLvoid*) glGetBufferSubDataARB;
  GLvoid* function(GLenum, GLenum) glMapBufferARB;
  GLboolean function(GLenum) glUnmapBufferARB;
  void function(GLenum, GLenum, GLint*) glGetBufferParameterivARB;
  void function(GLenum, GLenum, GLvoid*) glGetBufferPointervARB;
}
