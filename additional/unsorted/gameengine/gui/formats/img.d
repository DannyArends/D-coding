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

import std.stdio, std.string, std.file, std.conv, std.utf;
import sdl.sdlstructs, sdl.sdlfunctions, sdl.sdlimage;
import gl.gl_1_0, gl.gl_1_1, gl.gl_1_2;
import core.typedefs.types, core.terminal;

mixin(GenOutput!("IMG", "Green"));

Texture loadImageAsTexture(string filename, bool verbose = true){  
  Texture texture = Texture(filename);
  if(!exists(filename) || !filename.isFile){
    ERR("No such file: '%s'",filename);
    texture.status = FileStatus.NO_SUCH_FILE;
    return texture;
  }
  if(verbose) wIMG("Opening file: '%s'",filename);
  SDL_Surface* image;
  try{
    int flags=IMG_INIT_JPG|IMG_INIT_PNG;
    IMG_Init(flags);
    image = IMG_Load(toUTFz!(char*)(filename));
  }catch(Throwable t){
    ERR("Found SDL_image, but it fails to load");
  }
  if(image is null){
    wIMG("No surface: %s",to!string(cast(char*)IMG_GetError()));
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
  wIMG("Image %s (%d x %d) loaded", filename, texture.width, texture.height);
  return texture;
}

GLuint[] bufferTexture(Texture texture, bool verbose = false){
  texture.id = new GLuint[1];
  if((texture.width & (texture.width - 1)) != 0){ WARN("Image %s width is not a power of 2",texture.name); }
  if((texture.height & (texture.height - 1)) != 0){ WARN("Image %s height is not a power of 2",texture.name);}
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
    if(surface.format.Rmask == 0x000000ff) return GL_RGBA;
    return GL_BGRA;
  }else if(nOfColors == 3){
    if(surface.format.Rmask == 0x000000ff) return GL_RGB;
    return GL_BGR;
  }
  assert(0);
}
