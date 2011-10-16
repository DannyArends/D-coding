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

module gui.formats.o3ds;

import std.stdio;
import std.array;
import std.string;
import std.c.stdio;
import std.cstream;
import std.conv;
import std.file;
import std.regex;

private import core.arrays.algebra;

private import gl.gl_1_0;
private import gl.gl_1_1;
private import gl.gl_1_5;
private import gl.gl_ext;

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

struct Material3DS{
  string      name;
  int         ambient[4];
  int         diffuse[4];
  int         specular[4];
  string      texture;
};

struct Object3DS{
	string          name;
  
  vertextype[]    vertex;
  polygontype[]   polygon;
  mapcoordtype[]  mapcoord;
};

struct ModelInfo3DS{
  string          filename;
  Object3DS[]     objects;
  Material3DS[]   materials;
  float[][]       normals;
  int             nvertex;
  int             npolygons;
  
  bool            buffered  = false;
  GLuint          vertexbuffer;
  GLuint          colorbuffer;
};

bool bufferModelInfo3DS(ModelInfo3DS* model){
  // Generate And Bind The Vertex Buffer
  glGenBuffersARB(cast(int)model.objects.length, &model.vertexbuffer); // Objects
  glGenBuffersARB(cast(int)model.objects.length, &model.colorbuffer); // Colors
  writefln("Generated buffers: %d %d",model.vertexbuffer,model.colorbuffer);
  GLfloat[] verticesunpacked = new GLfloat[](9*model.npolygons);
  ubyte[] colorunpacked = new ubyte[](12*model.npolygons);

  int vcnt=0;
  int ccnt=0;
  foreach(Object3DS o3ds;model.objects){
    for(int x=0;x<o3ds.polygon.length;x++){
      for(int triside=0;triside<3;triside++){
        for(int sideloc=0;sideloc<3;sideloc++){
          int vertexnum = o3ds.polygon[x].p[triside];
          if(vertexnum >= o3ds.vertex.length){
            writefln("Model %s contains incomplete polygon at %d",o3ds.name,x);
            vertexnum=1;
          }
          verticesunpacked[vcnt] = o3ds.vertex[vertexnum].v[sideloc];
          vcnt++;
        }
      }
    }

    for(int x=0;x<o3ds.polygon.length;x++){
      int matnum = findMaterial(o3ds.polygon[x].material,model.materials);   //Find material for this edge
      for(int triside=0;triside<3;triside++){
        for(int color=0;color<4;color++){
          
          if(matnum >= 0){
            colorunpacked[ccnt] = cast(ubyte)model.materials[matnum].ambient[color];   //Set color
          }else{
            colorunpacked[ccnt] = cast(ubyte)color/4;   //Set color
          }
          ccnt++;
        }
      }
    }
  }
  glBindBufferARB(GL_ARRAY_BUFFER_ARB, model.vertexbuffer);
  glBufferDataARB(GL_ARRAY_BUFFER_ARB, model.npolygons*9*GLfloat.sizeof, verticesunpacked.ptr, GL_STATIC_DRAW_ARB);
  glBindBufferARB(GL_ARRAY_BUFFER_ARB, model.colorbuffer);
  glBufferDataARB(GL_ARRAY_BUFFER_ARB, model.npolygons*12*ubyte.sizeof, colorunpacked.ptr, GL_STATIC_DRAW_ARB);
  
  model.buffered = true;
  writefln("Buffering done");
  return model.buffered;
}

int findMaterial(string name, Material3DS[] materials){
  int cnt=0;
  foreach(Material3DS o; materials){
    if(o.name == name){
      return cnt;
    }
    cnt++;
  }
  return -1;
}


ModelInfo3DS* loadModelInfo3DS(string filename){
  if(!exists(filename) || !filename.isFile){
    writefln("No such file: %s",filename);
    return null;
  }
  writefln("Opening 3ds-file: %s",filename);
  string materialname = "";
  string objectname   = "";
  string texturename  = "";
  ModelInfo3DS* fullmodel = new ModelInfo3DS();
  fullmodel.filename=filename;
  Object3DS* model;
  Material3DS* material;
  char r, g, b;
  ushort l_chunk_id;
  uint l_chunk_length;
  ubyte l_char;
  ushort l_qty, temp;
  ushort l_face_flags;
  bool is_diffuse, is_specular, is_ambient;
  auto fp = new std.stdio.File(filename,"rb");
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
      if(model!=null) fullmodel.objects ~= (*model);
      model = new Object3DS();
      model.name = objectname;
    break; 
    case 0x4100: break; 
    case 0x4110: 
      fread(&l_qty, ushort.sizeof, 1, f);
      model.vertex = new vertextype[l_qty];
      fullmodel.nvertex += l_qty;
      for(uint i=0; i<l_qty; i++){
        fread(&model.vertex[i].v[0], float.sizeof, 1, f);
        fread(&model.vertex[i].v[1], float.sizeof, 1, f);
        fread(&model.vertex[i].v[2], float.sizeof, 1, f);                            
      }
    break; 
    case 0x4120:
      fread(&l_qty,ushort.sizeof, 1, f);
      model.polygon = new polygontype[l_qty];
      fullmodel.npolygons += l_qty;
      for(uint i=0; i<l_qty; i++){
        fread(&model.polygon[i].p[0], ushort.sizeof, 1, f);
        fread(&model.polygon[i].p[1], ushort.sizeof, 1, f);
        fread(&model.polygon[i].p[2], ushort.sizeof, 1, f);
        fread(&l_face_flags, ushort.sizeof, 1, f);
      }
    break; 
    case 0x4130:
      if(!(materialname is "")) materialname = "";
      do{
        fread(&l_char, 1, 1, f);
        materialname ~= l_char;
      }while(l_char != '\0');
      fread(&l_qty, ushort.sizeof, 1, f);            
      for(uint i=0; i<l_qty; i++){
        fread(&temp, ushort.sizeof, 1, f);
        model.polygon[temp].material=materialname;
      }
    break;
    case 0xAFFF: break;
    case 0xA000:
      if(!(materialname is "")) materialname = "";
      do{
        fread (&l_char, 1, 1, f);
        materialname ~= l_char;
      }while(l_char != '\0');
      if(material!=null) fullmodel.materials ~= (*material);
      material = new Material3DS();
      material.name = materialname;
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
      material.texture = texturename;
    break;
    case 0x0011:
      fread(&r, char.sizeof, 1, f);
      fread(&g, char.sizeof, 1, f);
      fread(&b, char.sizeof, 1, f);
      if(is_diffuse){
        material.diffuse[0] = r;
        material.diffuse[1] = g;
        material.diffuse[2] = b;
      }else if(is_ambient){
        writefln("%d %d %d",r,g,b);
        material.ambient[0] = r;
        material.ambient[1] = g;
        material.ambient[2] = b;
      }else if(is_specular){
        material.specular[0] = r;
        material.specular[1] = g;
        material.specular[2] = b;
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
  if(model!=null) fullmodel.objects ~= (*model);
  if(material!=null) fullmodel.materials ~= (*material);
  fp.close();
  writefln("Loaded 3ds-file: %s, %d objects, %d materials",filename, fullmodel.objects.length,fullmodel.materials.length);
  foreach(Object3DS m;fullmodel.objects){
    float     triangle[3][3];
    for(int x=0;x<m.polygon.length;x++){
      for(int triside=0;triside<3;triside++){
        for(int sideloc=0;sideloc<3;sideloc++){
          int vertexnum = m.polygon[x].p[triside];
          triangle[triside][sideloc] = m.vertex[vertexnum].v[sideloc];
          fullmodel.normals ~= trianglefindnormal!float(triangle);
        }
      }
    }
  }
  writefln("Calculated normals, object %s OK",filename);
  return fullmodel;
}
