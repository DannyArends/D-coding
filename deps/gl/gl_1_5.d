module gl.gl_1_5;

import std.c.stdio, std.c.stdarg;
import gl.gl_1_0, gl.gl_1_1, gl.gl_1_2, gl.gl_1_3, gl.gl_1_4;

/* OpenGL 1.2 */
enum : GLenum{
  GL_BUFFER_SIZE                     = 0x8764,
  GL_BUFFER_USAGE                    = 0x8765,
  GL_QUERY_COUNTER_BITS              = 0x8864,
  GL_CURRENT_QUERY                   = 0x8865,
  GL_QUERY_RESULT                    = 0x8866,
  GL_QUERY_RESULT_AVAILABLE          = 0x8867,
  GL_ARRAY_BUFFER                    = 0x8892,
  GL_ELEMENT_ARRAY_BUFFER            = 0x8893,
  GL_ARRAY_BUFFER_BINDING            = 0x8894,
  GL_ELEMENT_ARRAY_BUFFER_BINDING    = 0x8895,
  GL_VERTEX_ARRAY_BUFFER_BINDING     = 0x8896,
  GL_NORMAL_ARRAY_BUFFER_BINDING     = 0x8897,
  GL_COLOR_ARRAY_BUFFER_BINDING      = 0x8898,
  GL_INDEX_ARRAY_BUFFER_BINDING      = 0x8899,
  GL_TEXTURE_COORD_ARRAY_BUFFER_BINDING = 0x889A,
  GL_EDGE_FLAG_ARRAY_BUFFER_BINDING  = 0x889B,
  GL_SECONDARY_COLOR_ARRAY_BUFFER_BINDING = 0x889C,
  GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING = 0x889D,
  GL_WEIGHT_ARRAY_BUFFER_BINDING     = 0x889E,
  GL_VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F,
  GL_READ_ONLY                       = 0x88B8,
  GL_WRITE_ONLY                      = 0x88B9,
  GL_READ_WRITE                      = 0x88BA,
  GL_BUFFER_ACCESS                   = 0x88BB,
  GL_BUFFER_MAPPED                   = 0x88BC,
  GL_BUFFER_MAP_POINTER              = 0x88BD,
  GL_STREAM_DRAW                     = 0x88E0,
  GL_STREAM_READ                     = 0x88E1,
  GL_STREAM_COPY                     = 0x88E2,
  GL_STATIC_DRAW                     = 0x88E4,
  GL_STATIC_READ                     = 0x88E5,
  GL_STATIC_COPY                     = 0x88E6,
  GL_DYNAMIC_DRAW                    = 0x88E8,
  GL_DYNAMIC_READ                    = 0x88E9,
  GL_DYNAMIC_COPY                    = 0x88EA,
  GL_SAMPLES_PASSED                  = 0x8914,
  GL_FOG_COORD_SRC                   = GL_FOG_COORDINATE_SOURCE,
  GL_FOG_COORD                       = GL_FOG_COORDINATE,
  GL_CURRENT_FOG_COORD               = GL_CURRENT_FOG_COORDINATE,
  GL_FOG_COORD_ARRAY_TYPE            = GL_FOG_COORDINATE_ARRAY_TYPE,
  GL_FOG_COORD_ARRAY_STRIDE          = GL_FOG_COORDINATE_ARRAY_STRIDE,
  GL_FOG_COORD_ARRAY_POINTER         = GL_FOG_COORDINATE_ARRAY_POINTER,
  GL_FOG_COORD_ARRAY                 = GL_FOG_COORDINATE_ARRAY,
  GL_FOG_COORD_ARRAY_BUFFER_BINDING  = GL_FOG_COORDINATE_ARRAY_BUFFER_BINDING,
  GL_SRC0_RGB                        = GL_SOURCE0_RGB,
  GL_SRC1_RGB                        = GL_SOURCE1_RGB,
  GL_SRC2_RGB                        = GL_SOURCE2_RGB,
  GL_SRC0_ALPHA                      = GL_SOURCE0_ALPHA,
  GL_SRC1_ALPHA                      = GL_SOURCE1_ALPHA,
  GL_SRC2_ALPHA                      = GL_SOURCE2_ALPHA,
}

/* 1.5 functions */
extern (System){
  GLvoid function(GLsizei, GLuint*) glGenQueries;
  GLvoid function(GLsizei,GLuint*) glDeleteQueries;
  GLboolean function(GLuint) glIsQuery;
  GLvoid function(GLenum, GLuint) glBeginQuery;
  GLvoid function(GLenum) glEndQuery;
  GLvoid function(GLenum, GLenum, GLint*) glGetQueryiv;
  GLvoid function(GLuint, GLenum, GLint*) glGetQueryObjectiv;
  GLvoid function(GLuint, GLenum, GLuint*) glGetQueryObjectuiv;
  GLvoid function(GLenum, GLuint) glBindBuffer;
  GLvoid function(GLsizei, GLuint*) glDeleteBuffers;
  GLvoid function(GLsizei, GLuint*) glGenBuffers;
  GLboolean function(GLuint) glIsBuffer;
  GLvoid function(GLenum, GLsizeiptr, GLvoid*, GLenum) glBufferData;
  GLvoid function(GLenum, GLintptr, GLsizeiptr,GLvoid*) glBufferSubData;
  GLvoid function(GLenum, GLintptr, GLsizeiptr, GLvoid*) glGetBufferSubData;
  GLvoid* function(GLenum, GLenum) glMapBuffer;
  GLboolean function(GLenum) glUnmapBuffer;
  GLvoid function(GLenum, GLenum, GLint*) glGetBufferParameteriv;
  GLvoid function(GLenum, GLenum, GLvoid**) glGetBufferPointerv;
}
