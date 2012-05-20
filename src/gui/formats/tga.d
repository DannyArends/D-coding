/******************************************************************//**
 * \file src/gui/formats/tga.d
 * \brief TGA file format definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.formats.tga;

import std.stdio, std.array, std.string, std.c.stdio, std.cstream;
import std.conv, std.file, std.regex;
import core.arrays.types;
import core.typedefs.types, core.typedefs.color;
import gl.gl_1_0, gl.gl_1_1;

uint getDataSize(Texture texture){
 return texture.height * texture.width * texture.bpp;
}

Texture doScreenshot(uint width, uint height, string filename="screen.tga"){
  Texture screenshot = Texture(filename);
  screenshot.width   = width;
  screenshot.height  = height;
  screenshot.type    = GL_RGBA;
  screenshot.bpp     = 4;
  screenshot.data = new ubyte[getDataSize(screenshot)];
  glReadPixels(0,0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, &screenshot.data[0]);
  return screenshot;
}

int loadTextureAsFont(GLint id){
  glEnable(GL_TEXTURE_2D);
  auto base = glGenLists(256);
  glBindTexture(GL_TEXTURE_2D, id);
  for(size_t offset=0; offset<256; offset++){
    float cx=cast(float)(offset%16)/16.0f;          // X Position Of Current Character
    float cy=cast(float)(offset/16)/16.0f;          // Y Position Of Current Character
    glNewList(base+offset,GL_COMPILE);              // Start Building A List
    glBegin(GL_QUADS);
      glTexCoord2f(cx,1.0f-cy-0.0625f);             // Texture Coord (Bottom Left)
      glVertex2d(0,16);                             // Vertex Coord (Bottom Left)
      glTexCoord2f(cx+0.0625f,1.0f-cy-0.0625f);     // Texture Coord (Bottom Right)
      glVertex2i(16,16);                            // Vertex Coord (Bottom Right)
      glTexCoord2f(cx+0.0625f,1.0f-cy-0.001f);      // Texture Coord (Top Right)
      glVertex2i(16,0);                             // Vertex Coord (Top Right)
      glTexCoord2f(cx,1.0f-cy-0.001f);              // Texture Coord (Top Left)
      glVertex2i(0,0);                              // Vertex Coord (Top Left)
    glEnd();
    glTranslated(14,0,0);                           // Move To The Right Of The Character
    glEndList();
  }
  glDisable(GL_TEXTURE_2D);
  return base;
}

Texture loadTgaAsTexture(string filename, bool verbose = false){
  Texture texture = Texture(filename);
  if(!exists(filename) || !filename.isFile){
    writefln("[TGA] No such file '%s'",filename);
    texture.status = FileStatus.NO_SUCH_FILE;
    return texture;
  }
  if(verbose) writefln("[TGA] Opening '%s'",filename);
  
  ubyte cGarbage;
  short iGarbage;
  ubyte aux;
  texture.type=GL_RGBA;
  auto fp = new std.stdio.File(filename,"rb");
  auto f = fp.getFP();
  ubyte tgatype;
  ubyte pixelDepth;
  
  fread(&cGarbage, ubyte.sizeof, 1, f);
  fread(&cGarbage, ubyte.sizeof, 1, f);  
  fread(&tgatype, ubyte.sizeof, 1, f);    // type must be 2 or 3
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&cGarbage, ubyte.sizeof, 1, f);
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&iGarbage, short.sizeof, 1, f);
  fread(&texture.width, short.sizeof, 1, f);
  fread(&texture.height, short.sizeof, 1, f);
  fread(&pixelDepth, ubyte.sizeof, 1, f);
  fread(&cGarbage, ubyte.sizeof, 1, f);

  if(tgatype == 1){
    writefln("[TGA] Unsupported format: %s",filename);
    texture.status = FileStatus.INDEXED_COLOR;
    fp.close(); 
    return texture;
  }
  if((tgatype != 2) && (tgatype !=3)){
    writefln("[TGA] Unsupported format: %s",tgatype);
    texture.status = FileStatus.COMPRESSED_FILE;
    fp.close(); 
    return texture;
  }
  
  texture.bpp = pixelDepth / 8;
  texture.data = new ubyte[getDataSize(texture)];
  if(texture.data == null){
    writeln("[TGA] ERROR: Unable to allocate memory required");
    texture.status = FileStatus.MEMORY;
    fp.close(); 
    return texture;
  }
  fread(&(texture.data[0]),ubyte.sizeof,getDataSize(texture),f);
  if(texture.bpp >= 3){
    for(size_t i=0; i < getDataSize(texture); i+= texture.bpp) {
      aux = texture.data[i];
      texture.data[i] = texture.data[i+2];
      texture.data[i+2] = aux;
    }
  }
  if(verbose) writefln("[TGA] File '%s' in memory",filename);
  if(texture.bpp == 3) texture.type = GL_RGB;
  
  texture.status = FileStatus.OK;
  fp.close();
  return texture;
}

Color[][] asColorMap(Texture texture){
  Color[][] colormap = newmatrix!Color(texture.width, texture.height, new Color());
  if(texture.status == FileStatus.OK){
    int x=0;
    int z=0;
    for(size_t i=0; i < (getDataSize(texture)-texture.bpp); i+= texture.bpp) {
      if(x < (texture.height-1)){
        x++;
      }else{
        x=0;
        z++;
      }
      colormap[z][x] = new Color(texture.data[i..i+3]);
    }
  }
  return colormap;
}

T[][] heightFromAlpha(T)(Texture texture, float scale = 5.0, float add = 0.0){
  T[][] map = newmatrix!T(texture.width, texture.height,cast(T)add);
  if(texture.status == FileStatus.OK){
    int x=0;
    int z=0;
    for(size_t i=0; i < (getDataSize(texture)-texture.bpp); i+= texture.bpp) {
      if(x < (texture.height-1)){
        x++;
      }else{
        x=0;
        z++;
      }
      map[z][x] = cast(T)((((texture.data[i+3])/255.0)*scale)+add);
    }
  }
  return map;
}

bool[][] dampFromAlpha(Texture texture){
  return heightFromAlpha!bool(texture,1);
}

void save(Texture texture, string filename) {
  ubyte cGarbage = 0;
  short iGarbage = 0;
  uint mode;
  ubyte aux;
  GLuint type=GL_RGBA;
  auto fp = new std.stdio.File(filename,"wb");
  auto f = fp.getFP();
  ubyte pixelDepth = cast(ubyte)(texture.bpp * 8);

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
  fwrite(&pixelDepth, ubyte.sizeof, 1,f);
  fwrite(&cGarbage, ubyte.sizeof, 1, f);

  if(texture.bpp >= 3){ // convert the image data from RGB(a) to BGR(A)
    for(size_t i=0; i < (getDataSize(texture)-texture.bpp) ; i+= texture.bpp){
      aux = texture.data[i];
      texture.data[i] = texture.data[i+2];
      texture.data[i+2] = aux;
    }
  }
  fwrite(&texture.data[0], ubyte.sizeof, getDataSize(texture), f);
  fp.close();
  writefln("[TGA] Saved file: %s",filename);
}
