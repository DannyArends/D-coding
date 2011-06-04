/**
 * \file tga.D
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: TGA
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module gui.formats.tga;

import std.stdio;
import std.array;
import std.string;
import std.c.stdio;
import std.cstream;
import std.conv;
import std.file;
import std.regex;

import gl.gl_1_0;
import gl.gl_1_1;

enum TgaType{ 
  TGA_ERROR_FILE_OPEN = -5, 
  TGA_ERROR_READING_FILE = -4, 
  TGA_ERROR_INDEXED_COLOR = -3, 
  TGA_ERROR_MEMORY = -2, 
  TGA_ERROR_COMPRESSED_FILE = -1, 
  TGA_OK = 0
}

struct tgaInfo{
	int             status;
  uint            textureID;
  short           width, height;
	ubyte           type, pixelDepth;
 	ubyte[]         imageData;
};

class TGA{

  bool load(string filename){
    if(!exists(filename) || !isfile(filename)) return false;
    writefln("Opening tga-file: %s",filename);
    
    ubyte cGarbage;
    short iGarbage;
    tgaInfo* info;
    ubyte aux;
    GLuint type=GL_RGBA;
    auto fp = new File(filename,"rb");
    auto f = fp.getFP();
    
    fread(&cGarbage, ubyte.sizeof, 1, f);
    fread(&cGarbage, ubyte.sizeof, 1, f);

    fread(&info.type, ubyte.sizeof, 1, f);    // type must be 2 or 3
    fread(&iGarbage, short.sizeof, 1, f);
    fread(&iGarbage, short.sizeof, 1, f);
    fread(&cGarbage, ubyte.sizeof, 1, f);
    fread(&iGarbage, short.sizeof, 1, f);
    fread(&iGarbage, short.sizeof, 1, f);
    fread(&info.width, short.sizeof, 1, f);
    fread(&info.height, short.sizeof, 1, f);
    fread(&info.pixelDepth, ubyte.sizeof, 1, f);
    fread(&cGarbage, ubyte.sizeof, 1, f);
    
    if (info.type == 1) { // check if the image is color indexed
      info.status = TgaType.TGA_ERROR_INDEXED_COLOR;
      fp.close(); return false;
    }
    if ((info.type != 2) && (info.type !=3)) { // check for other types (compressed images)
      info.status = TgaType.TGA_ERROR_COMPRESSED_FILE;
      fp.close(); return false;
    }
    
    uint mode = info.pixelDepth / 8;
    uint total = info.height * info.width * mode;
    info.imageData = new ubyte[total];
    if (info.imageData == null) {  // check to make sure we have the memory required
      info.status = TgaType.TGA_ERROR_MEMORY;
      fp.close(); return false;
    }
    fread(&info.imageData,ubyte.sizeof,total,f);
    if(mode >= 3){
      for(uint i=0; i < total; i+= mode) {
        aux = info.imageData[i];
        info.imageData[i] = info.imageData[i+2];
        info.imageData[i+2] = aux;
      }
    }
    glGenTextures(1, &(info.textureID));					// Generate OpenGL texture IDs
    glBindTexture(GL_TEXTURE_2D, info.textureID);			// Bind Our Texture
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);	// Linear Filtered
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);	// Linear Filtered
	  if (info.pixelDepth == 24){
      type=GL_RGB;
    }
    glTexImage2D(GL_TEXTURE_2D, 0, type, info.width, info.height, 0, type, GL_UNSIGNED_BYTE, cast(void*)info.imageData);
    info.status = TgaType.TGA_OK;
    fp.close();
    writefln("Loaded tga-file: %s to buffer: %d",filename,info.textureID);
    return true;
  }
}
