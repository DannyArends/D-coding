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
  GLuint[]        textureID;
  short           width, height;
	ubyte           type, pixelDepth;
 	ubyte[]         imageData;
};

tgaInfo* doScreenshot(short width, short height, string filename="screen.tga"){
  tgaInfo* screenshot = new tgaInfo();
  screenshot.width=width;
  screenshot.height=height;
  screenshot.type=2;
  screenshot.pixelDepth=32;
  uint total = screenshot.height * screenshot.width * (screenshot.pixelDepth/8);
  screenshot.imageData = new ubyte[total];
  glReadPixels(0,0,width,height,GL_RGBA,GL_UNSIGNED_BYTE, &screenshot.imageData[0]);
  return screenshot;
}

int loadAsFont(tgaInfo* tga){
  glEnable(GL_TEXTURE_2D);
  auto base = glGenLists(256);
  glBindTexture(GL_TEXTURE_2D, tga.textureID[0]);
  for(int offset=0; offset<256; offset++){
    float cx=cast(float)(offset%16)/16.0f;					// X Position Of Current Character
    float cy=cast(float)(offset/16)/16.0f;					// Y Position Of Current Character
    glNewList(base+offset,GL_COMPILE);					    // Start Building A List
    glBegin(GL_QUADS);
      glTexCoord2f(cx,1.0f-cy-0.0625f);			        // Texture Coord (Bottom Left)
      glVertex2d(0,16);							                // Vertex Coord (Bottom Left)
      glTexCoord2f(cx+0.0625f,1.0f-cy-0.0625f);	    // Texture Coord (Bottom Right)
      glVertex2i(16,16);							              // Vertex Coord (Bottom Right)
      glTexCoord2f(cx+0.0625f,1.0f-cy-0.001f);	    // Texture Coord (Top Right)
      glVertex2i(16,0);							                // Vertex Coord (Top Right)
      glTexCoord2f(cx,1.0f-cy-0.001f);		        	// Texture Coord (Top Left)
      glVertex2i(0,0);							                // Vertex Coord (Top Left)
    glEnd();
    glTranslated(14,0,0);							              // Move To The Right Of The Character
    glEndList();
  }
  glDisable(GL_TEXTURE_2D);
  return base;
}

int loadFileAsFont(string filename){
  return loadAsFont(loadTexture(filename));
}

tgaInfo* loadTexture(string filename){
  if(!exists(filename) || !isfile(filename)){
    writefln("No such file: %s",filename);
    return null;
  }
  writefln("Opening tga-file: %s",filename);
  
  ubyte cGarbage;
  short iGarbage;
  tgaInfo* texture = new tgaInfo();
  ubyte aux;
  GLuint type=GL_RGBA;
  auto fp = new std.stdio.File(filename,"rb");
  auto f = fp.getFP();
  
  fread(&cGarbage, ubyte.sizeof, 1, f);
  fread(&cGarbage, ubyte.sizeof, 1, f);

  fread(&texture.type, ubyte.sizeof, 1, f);    // type must be 2 or 3
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&cGarbage, ubyte.sizeof, 1, f);
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&texture.width, short.sizeof, 1, f);
  fread(&texture.height, short.sizeof, 1, f);
  fread(&texture.pixelDepth, ubyte.sizeof, 1, f);
  fread(&cGarbage, ubyte.sizeof, 1, f);
  
  if(texture.type == 1){
    writefln("Unsupported tga format: %s",filename);
    texture.status = TgaType.TGA_ERROR_INDEXED_COLOR;
    fp.close(); 
    return null;
  }
  if((texture.type != 2) && (texture.type !=3)){
    writefln("Unsupported tga format: %s",filename);
    texture.status = TgaType.TGA_ERROR_COMPRESSED_FILE;
    fp.close(); 
    return null;
  }
  
  uint mode = texture.pixelDepth / 8;
  uint total = texture.height * texture.width * mode;
  texture.imageData = new ubyte[total];
  if(texture.imageData == null){
    writefln("Unable to allocate memory required for tga-file: %s",filename);
    texture.status = TgaType.TGA_ERROR_MEMORY;
    fp.close(); 
    return null;
  }
  fread(&(texture.imageData[0]),ubyte.sizeof,total,f);
  if(mode >= 3){
    for(uint i=0; i < total; i+= mode) {
      aux = texture.imageData[i];
      texture.imageData[i] = texture.imageData[i+2];
      texture.imageData[i+2] = aux;
    }
  }
  writefln("Tga-file: %s in memory",filename);
  texture.textureID = new GLuint[1];
  glEnable(GL_TEXTURE_2D);
  glGenTextures(3, &(texture.textureID[0]));					// Generate OpenGL texture IDs
  glBindTexture(GL_TEXTURE_2D, texture.textureID[0]);			// Bind Our Texture
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);	// Linear Filtered
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);	// Linear Filtered
  if (texture.pixelDepth == 24){
    type=GL_RGB;
  }
  glTexImage2D(GL_TEXTURE_2D, 0, type, texture.width, texture.height, 0, type, GL_UNSIGNED_BYTE, &(texture.imageData[0]));
  glDisable(GL_TEXTURE_2D);
  texture.status = TgaType.TGA_OK;
  fp.close();
  writefln("Loaded tga-file: %s to texture-buffer: %d",filename,texture.textureID);
  return texture;
}

void save(tgaInfo* texture, string filename) {
  ubyte cGarbage = 0;
  short iGarbage = 0;
  uint mode;
  ubyte aux;
  GLuint type=GL_RGBA;
  auto fp = new std.stdio.File(filename,"wb");
  auto f = fp.getFP();
  
  mode = texture.pixelDepth / 8; // compute image type: 2 for RGB(A), 3 for greyscale

  fwrite(&cGarbage, ubyte.sizeof, 1, f);
  fwrite(&cGarbage, ubyte.sizeof, 1, f);
  fwrite(&texture.type, ubyte.sizeof, 1, f);
  fwrite(&iGarbage, short.sizeof, 1, f);
  fwrite(&iGarbage, short.sizeof, 1, f);
  fwrite(&cGarbage, ubyte.sizeof, 1, f);
  fwrite(&iGarbage, short.sizeof, 1, f);
  fwrite(&iGarbage, short.sizeof, 1, f);
  fwrite(&texture.width, short.sizeof, 1, f);
  fwrite(&texture.height, short.sizeof, 1, f);
  fwrite(&texture.pixelDepth, ubyte.sizeof, 1,f);
  fwrite(&cGarbage, ubyte.sizeof, 1, f);

  if(mode >= 3){ // convert the image data from RGB(a) to BGR(A)
    for(int i=0; i < texture.width * texture.height * mode ; i+= mode) {
      aux = texture.imageData[i];
      texture.imageData[i] = texture.imageData[i+2];
      texture.imageData[i+2] = aux;
    }
  }
  fwrite(&texture.imageData[0], ubyte.sizeof, texture.width * texture.height * mode, f);
  fp.close();
  writefln("Saved tga-file: %s",filename);
}
