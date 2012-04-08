/**********************************************************************
 * \file src/gui/textureloader.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Dec, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.textureloader;

import core.stdinc;
import core.typedefs.types;

import gui.formats.tga;
import gui.formats.img;

class TextureLoader{

  void load(){
    foreach(string e; dirEntries("data/textures", SpanMode.breadth)){
      e = e[e.indexOf("data/")..$];
      if(isFile(e)){
        Texture texture;
        if(e.indexOf(".tga") > 0){
          writeln("[TEX] TGA:",e);
          texture = loadTgaAsTexture(e);
        }
        if(e.indexOf(".png") > 0 || e.indexOf(".jpg") > 0){
          writeln("[TEX] PNG/JPG:",e);
          texture = loadImageAsTexture(e);
        }
        if(texture.status == FileStatus.OK){
          texture.id = bufferTexture(texture);
          textures ~= texture;
        }
      }
    }
    writefln("[GFX] Buffered %d textures",textures.length);
  }
  
  void refreshAfterResize(bool verbose = false){
    for(auto x =0; x< textures.length;x++){
      textures[x].id = bufferTexture(textures[x],verbose);
    }
    if(verbose) writeln("[GFX] Refreshed " ~ to!string(textures.length) ~ " textures");
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
