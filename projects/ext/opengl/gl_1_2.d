module ext.opengl.gl_1_2;

import std.c.stdio, std.c.stdarg;
import ext.opengl.gl_1_0, ext.opengl.gl_1_1;

/* OpenGL 1.2 */
enum : GLenum{
  GL_RESCALE_NORMAL                  = 0x803A,
  GL_CLAMP_TO_EDGE                   = 0x812F,
  GL_MAX_ELEMENTS_VERTICES           = 0x80E8,
  GL_MAX_ELEMENTS_INDICES            = 0x80E9,
  GL_BGR                             = 0x80E0,
  GL_BGRA                            = 0x80E1,
  GL_UNSIGNED_BYTE_3_3_2             = 0x8032,
  GL_UNSIGNED_BYTE_2_3_3_REV         = 0x8362,
  GL_UNSIGNED_SHORT_5_6_5            = 0x8363,
  GL_UNSIGNED_SHORT_5_6_5_REV        = 0x8364,
  GL_UNSIGNED_SHORT_4_4_4_4          = 0x8033,
  GL_UNSIGNED_SHORT_4_4_4_4_REV      = 0x8365,
  GL_UNSIGNED_SHORT_5_5_5_1          = 0x8034,
  GL_UNSIGNED_SHORT_1_5_5_5_REV      = 0x8366,
  GL_UNSIGNED_INT_8_8_8_8            = 0x8035,
  GL_UNSIGNED_INT_8_8_8_8_REV        = 0x8367,
  GL_UNSIGNED_INT_10_10_10_2         = 0x8036,
  GL_UNSIGNED_INT_2_10_10_10_REV     = 0x8368,
  GL_LIGHT_MODEL_COLOR_CONTROL       = 0x81F8,
  GL_SINGLE_COLOR                    = 0x81F9,
  GL_SEPARATE_SPECULAR_COLOR         = 0x81FA,
  GL_TEXTURE_MIN_LOD                 = 0x813A,
  GL_TEXTURE_MAX_LOD                 = 0x813B,
  GL_TEXTURE_BASE_LEVEL              = 0x813C,
  GL_TEXTURE_MAX_LEVEL               = 0x813D,
  GL_SMOOTH_POINT_SIZE_RANGE         = 0x0B12,
  GL_SMOOTH_POINT_SIZE_GRANULARITY   = 0x0B13,
  GL_SMOOTH_LINE_WIDTH_RANGE         = 0x0B22,
  GL_SMOOTH_LINE_WIDTH_GRANULARITY   = 0x0B23,
  GL_ALIASED_POINT_SIZE_RANGE        = 0x846D,
  GL_ALIASED_LINE_WIDTH_RANGE        = 0x846E,
  GL_PACK_SKIP_IMAGES                = 0x806B,
  GL_PACK_IMAGE_HEIGHT               = 0x806C,
  GL_UNPACK_SKIP_IMAGES              = 0x806D,
  GL_UNPACK_IMAGE_HEIGHT             = 0x806E,
  GL_TEXTURE_3D                      = 0x806F,
  GL_PROXY_TEXTURE_3D                = 0x8070,
  GL_TEXTURE_DEPTH                   = 0x8071,
  GL_TEXTURE_WRAP_R                  = 0x8072,
  GL_MAX_3D_TEXTURE_SIZE             = 0x8073,
  GL_TEXTURE_BINDING_3D              = 0x806A,
}

/* 1.2 functions */
extern (System){
	GLvoid function(GLenum, GLuint, GLuint, GLsizei, GLenum, GLvoid*) glDrawRangeElements;
	GLvoid function(GLenum, GLint, GLint, GLsizei, GLsizei, GLsizei, GLint, GLenum, GLenum, GLvoid*) glTexImage3D;
	GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, GLvoid*) glTexSubImage3D;
	GLvoid function(GLenum, GLint, GLint, GLint, GLint, GLint, GLint, GLsizei, GLsizei) glCopyTexSubImage3D;
}
