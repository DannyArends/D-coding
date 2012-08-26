module gl.gl_1_4;

import std.c.stdio, std.c.stdarg;
import gl.gl_1_0;

/* OpenGL 1.4 */
enum : GLenum{
  GL_BLEND_DST_RGB                   = 0x80C8,
  GL_BLEND_SRC_RGB                   = 0x80C9,
  GL_BLEND_DST_ALPHA                 = 0x80CA,
  GL_BLEND_SRC_ALPHA                 = 0x80CB,
  GL_POINT_SIZE_MIN                  = 0x8126,
  GL_POINT_SIZE_MAX                  = 0x8127,
  GL_POINT_FADE_THRESHOLD_SIZE       = 0x8128,
  GL_POINT_DISTANCE_ATTENUATION      = 0x8129,
  GL_GENERATE_MIPMAP                 = 0x8191,
  GL_GENERATE_MIPMAP_HINT            = 0x8192,
  GL_DEPTH_COMPONENT16               = 0x81A5,
  GL_DEPTH_COMPONENT24               = 0x81A6,
  GL_DEPTH_COMPONENT32               = 0x81A7,
  GL_MIRRORED_REPEAT                 = 0x8370,
  GL_FOG_COORDINATE_SOURCE           = 0x8450,
  GL_FOG_COORDINATE                  = 0x8451,
  GL_FRAGMENT_DEPTH                  = 0x8452,
  GL_CURRENT_FOG_COORDINATE          = 0x8453,
  GL_FOG_COORDINATE_ARRAY_TYPE       = 0x8454,
  GL_FOG_COORDINATE_ARRAY_STRIDE     = 0x8455,
  GL_FOG_COORDINATE_ARRAY_POINTER    = 0x8456,
  GL_FOG_COORDINATE_ARRAY            = 0x8457,
  GL_COLOR_SUM                       = 0x8458,
  GL_CURRENT_SECONDARY_COLOR         = 0x8459,
  GL_SECONDARY_COLOR_ARRAY_SIZE      = 0x845A,
  GL_SECONDARY_COLOR_ARRAY_TYPE      = 0x845B,
  GL_SECONDARY_COLOR_ARRAY_STRIDE    = 0x845C,
  GL_SECONDARY_COLOR_ARRAY_POINTER   = 0x845D,
  GL_SECONDARY_COLOR_ARRAY           = 0x845E,
  GL_MAX_TEXTURE_LOD_BIAS            = 0x84FD,
  GL_TEXTURE_FILTER_CONTROL          = 0x8500,
  GL_TEXTURE_LOD_BIAS                = 0x8501,
  GL_INCR_WRAP                       = 0x8507,
  GL_DECR_WRAP                       = 0x8508,
  GL_TEXTURE_DEPTH_SIZE              = 0x884A,
  GL_DEPTH_TEXTURE_MODE              = 0x884B,
  GL_TEXTURE_COMPARE_MODE            = 0x884C,
  GL_TEXTURE_COMPARE_FUNC            = 0x884D,
  GL_COMPARE_R_TO_TEXTURE            = 0x884E,
  GL_CONSTANT_COLOR                  = 0x8001,
  GL_ONE_MINUS_CONSTANT_COLOR        = 0x8002,
  GL_CONSTANT_ALPHA                  = 0x8003,
  GL_ONE_MINUS_CONSTANT_ALPHA        = 0x8004,
  GL_BLEND_COLOR                     = 0x8005,
  GL_FUNC_ADD                        = 0x8006,
  GL_MIN                             = 0x8007,
  GL_MAX                             = 0x8008,
  GL_BLEND_EQUATION                  = 0x8009,
  GL_FUNC_SUBTRACT                   = 0x800A,
  GL_FUNC_REVERSE_SUBTRACT           = 0x800B,
}

/* 1.4 functions */
extern (System){
  GLvoid function(GLenum, GLenum, GLenum, GLenum) glBlendFuncSeparate;
  GLvoid function(GLfloat) glFogCoordf;
  GLvoid function(GLfloat*) glFogCoordfv;
  GLvoid function(GLdouble) glFogCoordd;
  GLvoid function(GLdouble*) glFogCoorddv;
  GLvoid function(GLenum, GLsizei,GLvoid*) glFogCoordPointer;
  GLvoid function(GLenum, GLint*, GLsizei*, GLsizei) glMultiDrawArrays;
  GLvoid function(GLenum, GLsizei*, GLenum, GLvoid**, GLsizei) glMultiDrawElements;
  GLvoid function(GLenum, GLfloat) glPointParameterf;
  GLvoid function(GLenum, GLfloat*) glPointParameterfv;
  GLvoid function(GLenum, GLint) glPointParameteri;
  GLvoid function(GLenum, GLint*) glPointParameteriv;
  GLvoid function(GLbyte, GLbyte, GLbyte) glSecondaryColor3b;
  GLvoid function(GLbyte*) glSecondaryColor3bv;
  GLvoid function(GLdouble, GLdouble, GLdouble) glSecondaryColor3d;
  GLvoid function(GLdouble*) glSecondaryColor3dv;
  GLvoid function(GLfloat, GLfloat, GLfloat) glSecondaryColor3f;
  GLvoid function(GLfloat*) glSecondaryColor3fv;
  GLvoid function(GLint, GLint, GLint) glSecondaryColor3i;
  GLvoid function(GLint*) glSecondaryColor3iv;
  GLvoid function(GLshort, GLshort, GLshort) glSecondaryColor3s;
  GLvoid function(GLshort*) glSecondaryColor3sv;
  GLvoid function(GLubyte, GLubyte, GLubyte) glSecondaryColor3ub;
  GLvoid function(GLubyte*) glSecondaryColor3ubv;
  GLvoid function(GLuint, GLuint, GLuint) glSecondaryColor3ui;
  GLvoid function(GLuint*) glSecondaryColor3uiv;
  GLvoid function(GLushort, GLushort, GLushort) glSecondaryColor3us;
  GLvoid function(GLushort*) glSecondaryColor3usv;
  GLvoid function(GLint, GLenum, GLsizei, GLvoid*) glSecondaryColorPointer;
  GLvoid function(GLdouble, GLdouble) glWindowPos2d;
  GLvoid function(GLdouble*) glWindowPos2dv;
  GLvoid function(GLfloat, GLfloat) glWindowPos2f;
  GLvoid function(GLfloat*) glWindowPos2fv;
  GLvoid function(GLint, GLint) glWindowPos2i;
  GLvoid function(GLint*) glWindowPos2iv;
  GLvoid function(GLshort, GLshort) glWindowPos2s;
  GLvoid function(GLshort*) glWindowPos2sv;
  GLvoid function(GLdouble, GLdouble, GLdouble) glWindowPos3d;
  GLvoid function(GLdouble*) glWindowPos3dv;
  GLvoid function(GLfloat, GLfloat, GLfloat) glWindowPos3f;
  GLvoid function(GLfloat*) glWindowPos3fv;
  GLvoid function(GLint, GLint, GLint) glWindowPos3i;
  GLvoid function(GLint*) glWindowPos3iv;
  GLvoid function(GLshort, GLshort, GLshort) glWindowPos3s;
  GLvoid function(GLshort*) glWindowPos3sv;
  GLvoid function(GLclampf, GLclampf, GLclampf, GLclampf) glBlendColor;
  GLvoid function(GLenum) glBlendEquation;
}
