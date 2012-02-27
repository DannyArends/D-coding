/******************************************************************//**
 * \file src/gui/formats/img.d
 * \brief Image format definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.formats.img;

import std.stdio;
import std.string;
import std.file;
import std.conv;

import sdl.sdlstructs;
import sdl.sdlfunctions;
import sdl.sdlimage;

import gl.gl_1_0;
import gl.gl_1_1;
import gl.gl_1_2;

import core.typedefs.types;

Texture loadImageAsTexture(string filename, bool verbose = true){  
  Texture texture = Texture(filename);
  if(!exists(filename) || !filename.isFile){
    writefln("[GFX] No such file: %s",filename);
    texture.status = FileStatus.NO_SUCH_FILE;
    return texture;
  }
  filename = filename ~ "\0";
  if(verbose) writefln("[GFX] Opening file: %s",filename);
  SDL_Surface* image = IMG_Load(filename.dup.ptr);
  if(image is null){
    writefln("[GFX] No surface: %s",to!string(cast(char*)IMG_GetError()));
    texture.status = FileStatus.NO_SUCH_FILE;  
    return texture;
  }
  texture.width  = image.w;
  texture.height = image.h;
  texture.bpp    = image.format.BytesPerPixel;
  texture.type   = getTextureType(image);
  int size       = texture.width*texture.height*texture.bpp;
  texture.data   = cast(ubyte[])image.pixels[0..size];
  texture.status = FileStatus.OK;
  writefln("[GFX] Image %s loaded: %dx%d:", 
         filename, texture.width, texture.height);
  return texture;
}

GLuint[] bufferTexture(Texture texture, bool verbose = false){
  texture.id = new GLuint[1];
  if((texture.width & (texture.width - 1)) != 0){
		writeln("[GFX] WARN: width is not a power of 2");
	}
	if((texture.height & (texture.height - 1)) != 0){
		writeln("[GFX] WARN: height is not a power of 2");
	}
	glGenTextures(1, &(texture.id[0]) );
	glBindTexture(GL_TEXTURE_2D, texture.id[0] );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
	glTexImage2D(GL_TEXTURE_2D, 0, texture.bpp, texture.width, texture.height, 0, texture.type, GL_UNSIGNED_BYTE, texture.data.ptr);
  return texture.id;
}

GLint getTextureType(SDL_Surface* surface){
  GLint nOfColors = surface.format.BytesPerPixel;
  if(nOfColors == 4){
    if(surface.format.Rmask == 0x000000ff){
      return GL_RGBA;
    }else{
      return GL_BGRA;
    }    
  }else if(nOfColors == 3){
    if(surface.format.Rmask == 0x000000ff){
      return GL_RGB;
    }else{
      return GL_BGR;
    }
  }
  assert(0);
}
