/******************************************************************//**
 * \file src/gui/textureloader.d
 * \brief Texture loader class
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.textureloader;

import core.stdinc;
import core.typedefs.types, core.terminal;
import gui.formats.tga, gui.formats.img;

mixin(GenOutput!("TEX", "Green"));

class TextureLoader{
  public:
  void load(){
    foreach(string e; dirEntries("data/textures", SpanMode.breadth)){
      e = e[e.indexOf("data/")..$];
      if(isFile(e)){
        Texture texture;
        if(e.indexOf(".tga") > 0){
          wTEX("TGA: '%s'",e);
          texture = loadTgaAsTexture(e);
        }
        if(e.indexOf(".png") > 0 || e.indexOf(".jpg") > 0){
          wTEX("PNG/JPG: '%s'",e);
          texture = loadImageAsTexture(e);
        }
        if(texture.status == FileStatus.OK){
          texture.id = bufferTexture(texture);
          textures ~= texture;
        }
      }
    }
    wTEX("Buffered %d textures",textures.length);
  }
  
  void refreshAfterResize(bool verbose = false){
    for(auto x =0; x< textures.length;x++){
      textures[x].id = bufferTexture(textures[x],verbose);
    }
    if(verbose) wTEX("Refreshed " ~ to!string(textures.length) ~ " textures");
  }
  
  Texture getTexture(string name){ 
    for(auto x =0; x< textures.length;x++){
      if(textures[x].name.indexOf(name) > 0){
        return textures[x]; 
      }
    }
    return Texture();
  }
  
  int getTextureID(string name){
    for(auto x =0; x< textures.length;x++){
      if(textures[x].name.indexOf(name) > 0){
        return textures[x].id[0];
      }
    }
    return 0;
  }
  
private:
  Texture[]     textures;
}
