import std.stdio, std.conv, std.file, std.utf, std.array;
import ext.opengl.gl, ext.sdl.sdl;
import objects;

Texture loadTexture(string fn){
  if(exists(fn) && isFile(fn)){
    IMG_Init(IMG_INIT_JPG | IMG_INIT_PNG);
    SDL_Surface* image = IMG_Load(toUTFz!(char*)(fn));
    if(image !is null){
      GLuint[] id = new GLuint[1];
      glGenTextures(1, &(id[0]) );
      glBindTexture(GL_TEXTURE_2D, id[0] );
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
      glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
      int     bpp  = image.format.BytesPerPixel;
      int     size = image.w * image.h * bpp;
      ubyte[] data = (cast(ubyte[]) image.pixels[0 .. size]).reverse;
      GLint   type = texureType(bpp, image.format.Rmask);
      if(type > 0){
        Texture t = Texture(id[0], image.w, image.h, bpp, type, data.dup);
        glTexImage2D(GL_TEXTURE_2D, 0, bpp, image.h, image.w, 0, type, GL_UNSIGNED_BYTE, data.ptr);
        writefln("File %s loaded, id: %s", fn, id[0]);
        return t;
      }else{ writefln("Wrong color format %s", fn); }
    }else{ writefln("Unable to load image from %s", fn); }
  }else{ writefln("No such file: %s", fn); }
  return Texture(-1);
}

GLuint textureAsFont(GLint id){
  glEnable(GL_TEXTURE_2D);
  GLuint base = glGenLists(256);
  glBindTexture(GL_TEXTURE_2D, id);
  for(auto offset = 0; offset < 256; offset++){
    float cx = to!float((255-offset) % 16) / 16;  // X Position Of Current Character
    float cy = to!float(offset / 16) / 16;        // Y Position Of Current Character
    glNewList(base+offset,GL_COMPILE);            // Start Building A List
    glBegin(GL_QUADS);
      glTexCoord2f(cx+0.0625f, 1.0f-cy-0.0625f);  // Texture Coord (Bottom Right)
      glVertex2d(0, 16);                          // Vertex Coord  (Bottom Left)
      glTexCoord2f(cx, 1.0f-cy-0.0625f);          // Texture Coord (Bottom Left)
      glVertex2i(16, 16);                         // Vertex Coord  (Bottom Right)
      glTexCoord2f(cx, 1.0f-cy-0.001f);           // Texture Coord (Top Left)
      glVertex2i(16, 0);                          // Vertex Coord  (Top Right)
      glTexCoord2f(cx+0.0625f, 1.0f-cy-0.001f);   // Texture Coord (Top Right)
      glVertex2i(0, 0);                           // Vertex Coord  (Top Left)
    glEnd();
    glTranslated(14, 0, 0);                       // Move To The Right Of The Character
    glEndList();
  }
  glDisable(GL_TEXTURE_2D);
  writefln("Texture %s as font to displaylist: %s", id, base);
  return base;
}

GLint texureType(GLint nColors, GLfloat Rmask){
  if(nColors == 4){ if(Rmask == 0x000000ff){ return GL_RGBA; }else{ return GL_BGRA; } }
  if(nColors == 3){ if(Rmask == 0x000000ff){ return GL_RGB;  }else{ return GL_BGR; } }
  return -1;
}

