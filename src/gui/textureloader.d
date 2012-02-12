module gui.textureloader;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import std.file;
import std.regex;

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
          texture = loadTgaAsTexture(e);
        }
        if(e.indexOf(".png") > 0 || e.indexOf(".jpg") > 0){
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
