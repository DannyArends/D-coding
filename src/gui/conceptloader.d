module gui.conceptloader;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import std.file;
import std.regex;
import core.typedefs.eventhandling;

import gui.enginefunctions;
import gui.formats.tga;

enum LoaderType {TEXTURE, MAP, OBJECT3DS, HUDWINDOW };

abstract class EngineLoader{
  LoaderType type;
  abstract void load();
}

class Object3DSLoader : EngineLoader{
  this(){
    type = LoaderType.OBJECT3DS;
  }
}

class MapLoader : EngineLoader{
  this(){
    type = LoaderType.OBJECT3DS;
  }
}

class HudWindowLoader : EngineLoader{
  this(){
    type = LoaderType.HUDWINDOW;
  }
}

class TextureLoader : EngineLoader{
  this(){
    type = LoaderType.TEXTURE;
  }
  
  void load(){
    textures.length = 0;
    foreach(string e; dirEntries("data/textures", SpanMode.breadth)){
      e = e[e.indexOf("data/")..$];
      if(isFile(e) && e.indexOf(".tga") > 0){
        tgaInfo texture = loadTexture(e);
        texture.textureID = toTextureBuffer(texture);
        textures ~= texture;
      }
    }
  }
  
  void refreshAfterResize(bool verbose = false){
    for(auto x =0; x< textures.length;x++){
      textures[x].textureID = toTextureBuffer(textures[x],verbose);
    }
    if(verbose)writeln("Refreshed " ~ to!string(textures.length) ~ " textures");
  }
  
  int getTextureID(string name){
    for(auto x =0; x< textures.length;x++){
      if(textures[x].name.indexOf(name) > 0){
        return textures[x].textureID[0];
      }
    }
    return 0;
  }

  tgaInfo getTexture(string name){
    for(auto x =0; x< textures.length;x++){
      if(textures[x].name.indexOf(name) > 0){
        return textures[x];
      }
    }
    return tgaInfo("Unknown");
  }
  
private:
  tgaInfo[]       textures;  
}
