/**
 * \file object3ds.D
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
 * Contains: model3ds
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/

module gui.formats.object3ds;

import std.stdio;
import std.array;
import std.string;
import std.c.stdio;
import std.cstream;
import std.conv;
import std.file;
import std.regex;

struct vertextype{
  int boneID;
  float v[3];
};

struct polygontype{
  string material;
  ushort p[3];
};

struct mapcoordtype{
  float u,v;
};

struct material3ds{
  string      name;
  int         ambient[4];
  int         diffuse[4];
  int         specular[4];
  string      texture;
};

struct object3ds{
	string          name;

  vertextype[]    vertex;
  polygontype[]   polygon;
  mapcoordtype[]  mapcoord;
};

class model3ds{
  object3ds[] objects;
  material3ds[] materials;
  
  this(){
  
  }

  bool load(string filename){
    if(!exists(filename) || !isfile(filename)) return false;
    writefln("Opening 3ds-file: %s",filename);
    string materialname = "";
    string objectname   = "";
    string texturename  = "";
    object3ds* model;
    char r, g, b;
    ushort l_chunk_id;
    uint l_chunk_length;
    ubyte l_char;
    ushort l_qty, temp;
    ushort l_face_flags;
    bool is_diffuse, is_specular, is_ambient;
    auto fp = new File(filename,"rb");
    auto f = fp.getFP();
    while (fp.tell() < getSize(filename)){    //Loop to scan the whole file 
      fread(&l_chunk_id, 2, 1, f);            //Read the chunk header
      fread(&l_chunk_length, 4, 1, f);        //Read the length of the chunk
      switch(l_chunk_id){
      case 0x4d4d: break; 
      case 0x3d3d: break; 
      case 0x4000:
        if(!(objectname is "")) objectname = "";
        do{
          fread(&l_char, 1, 1, f);
          objectname ~= cast(char)l_char;
        }while(l_char != '\0');
        if(model!=null) objects ~= (*model);
        model = new object3ds();
      break; 
      case 0x4100: break; 
      case 0x4110: 
        fread(&l_qty, ushort.sizeof, 1, f);
        model.vertex = new vertextype[l_qty];
        for(uint i=0; i<l_qty; i++){
          fread(&model.vertex[i].v[0], float.sizeof, 1, f);
          fread(&model.vertex[i].v[1], float.sizeof, 1, f);
          fread(&model.vertex[i].v[2], float.sizeof, 1, f);                            
        }
      break; 
      case 0x4120:
        fread(&l_qty,ushort.sizeof, 1, f);
        model.polygon = new polygontype[l_qty];
        for(uint i=0; i<l_qty; i++){
          fread(&model.polygon[i].p[0], ushort.sizeof, 1, f);
          fread(&model.polygon[i].p[1], ushort.sizeof, 1, f);
          fread(&model.polygon[i].p[2], ushort.sizeof, 1, f);
          fread(&l_face_flags, ushort.sizeof, 1, f);
        }
      break; 
      case 0x4130:
          do{
            fread(&l_char, 1, 1, f);
            materialname ~= l_char;
          }while(l_char != '\0');
          fread (&l_qty, ushort.sizeof, 1, f);            
          for(uint i=0; i<l_qty; i++){
            fread (&temp, ushort.sizeof, 1, f);
          }
      break;
      case 0xAFFF: break;
      case 0xA000:
        if(!(materialname is "")) materialname = "";
        do{
          fread (&l_char, 1, 1, f);
          materialname ~= l_char;
        }while(l_char != '\0');
      break;       
      case 0xA010:
        is_diffuse = false;is_specular = false;is_ambient = true;
      break;
      case 0xA020:   
        is_diffuse = true; is_specular = false;is_ambient = false;
      break;
      case 0xA030: 
        is_diffuse = false;is_specular = true; is_ambient = false;   
      break;
      case 0xA200: break;
      case 0xA300:
        if(!(texturename is "")) texturename = "";
        do{
          fread(&l_char, 1, 1, f);
          texturename ~= l_char;
        }while(l_char != '\0');
      break;
      case 0x0011:
        fread(&r, char.sizeof, 1, f);
        fread(&g, char.sizeof, 1, f);
        fread(&b, char.sizeof, 1, f);
        if(is_diffuse){
          //material->diffuse[0] = GetRValue(RGB(r,g,b));
          //material->diffuse[1] = GetGValue(RGB(r,g,b));
          //material->diffuse[2] = GetBValue(RGB(r,g,b));                            
        }else if(is_ambient){
          //material->ambient[0] = GetRValue(RGB(r,g,b));
          //material->ambient[1] = GetGValue(RGB(r,g,b));
          //material->ambient[2] = GetBValue(RGB(r,g,b));  
        }else if(is_specular){
          //material->specular[0] = GetRValue(RGB(r,g,b));
          //material->specular[1] = GetGValue(RGB(r,g,b));
          //material->specular[2] = GetBValue(RGB(r,g,b));  
        }       
      break;
      case 0x4140:
        fread (&l_qty, ushort.sizeof, 1, f);
        model.mapcoord = new mapcoordtype[l_qty];
        for (uint i=0; i<l_qty; i++){
          fread(&model.mapcoord[i].u, float.sizeof, 1, f);
          fread(&model.mapcoord[i].v, float.sizeof, 1, f);
        }
      break;
      default:
        fp.seek(l_chunk_length-6, SEEK_CUR);
      break;
    } 
  }
  fp.close();
  writefln("Loaded 3ds-file: %s, %d objects",filename, objects.length);
  return true;
  }
}
