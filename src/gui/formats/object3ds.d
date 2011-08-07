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
  object3ds[]     objects;
  material3ds[]   materials;
  
  bool            buffered  = false;
  int             nvertex   = 0;
  int             npolygons = 0;
  GLuint          vertexbuffer;
  GLuint          colorbuffer;  
  
  this(){
  
  }
  
  void buffer(){
    // Generate And Bind The Vertex Buffer
    glGenBuffersARB(cast(int)objects.length, &vertexbuffer); // Objects
    glGenBuffersARB(cast(int)objects.length, &colorbuffer); // Colors
    writefln("Generated buffers: %d %d",vertexbuffer,colorbuffer);
    GLfloat verticesunpacked[];
    ubyte[] colorunpacked;
    
    verticesunpacked.length = 9*npolygons;
    colorunpacked.length = 12*npolygons;
    int vcnt=0;
    int ccnt=0;
    foreach(object3ds model;objects){
      for(int x=0;x<model.polygon.length;x++){
        for(int triside=0;triside<3;triside++){
          for(int sideloc=0;sideloc<3;sideloc++){
            int vertexnum = model.polygon[x].p[triside];
            if(vertexnum >= model.vertex.length){
              writefln("Model %s contains incomplete polygon at %d",model.name,x);
              vertexnum=1;
            }
            verticesunpacked[vcnt] = model.vertex[vertexnum].v[sideloc];
            vcnt++;
          }
        }
      }

      for(int x=0;x<model.polygon.length;x++){
        int matnum = findMaterial(model.polygon[x].material);   //Find material for this edge
        for(int triside=0;triside<3;triside++){
          for(int color=0;color<4;color++){
            
            if(matnum >= 0){
              colorunpacked[ccnt] = cast(ubyte)materials[matnum].ambient[color];   //Set color
            }else{
              colorunpacked[ccnt] = cast(ubyte)color/4;   //Set color
            }
            ccnt++;
          }
        }
      }
    }
    glBindBufferARB(GL_ARRAY_BUFFER_ARB, vertexbuffer);
    glBufferDataARB(GL_ARRAY_BUFFER_ARB, npolygons*9*GLfloat.sizeof, &verticesunpacked[0], GL_STATIC_DRAW_ARB);
    glBindBufferARB(GL_ARRAY_BUFFER_ARB, colorbuffer);
    glBufferDataARB(GL_ARRAY_BUFFER_ARB, npolygons*12*ubyte.sizeof, &colorunpacked[0], GL_STATIC_DRAW_ARB);
    
    buffered = true;
    writefln("Buffering done");
  }
  
  int findMaterial(string name){
    int cnt=0;
    foreach(material3ds o; materials){
      if(o.name == name){
        return cnt;
      }
      cnt++;
    }
    return -1;
  }
  
  
  void render(){
    glPushMatrix();
    //glTranslatef(x, y, z);
    glScalef(  0.1f,  0.1f, 0.1f);
    glRotatef( 90.0f,-1.0f, 0.0f, 0.0f);  
    if(!buffered){
      float     triangle[3][3];
      float     normal[3];
     
      foreach(object3ds model;objects){
        for(int x=0;x<model.polygon.length;x++){
          for(int triside=0;triside<3;triside++){
            for(int sideloc=0;sideloc<3;sideloc++){
              int vertexnum = model.polygon[x].p[triside];
              triangle[triside][sideloc] = model.vertex[vertexnum].v[sideloc];
              normal = trianglefindnormal!float(triangle);
            }
          }
          glColor3f(1.0f, 0.0f, 0.0f);

          glBegin(GL_TRIANGLES);
          glNormal3f(normal[0], normal[1], normal[2]);
          glTexCoord2f(model.mapcoord[model.polygon[x].p[0]].u,model.mapcoord[model.polygon[x].p[0]].v);
          glVertex3f(triangle[0][0],triangle[0][1],triangle[0][2]); //Vertex definition

          glTexCoord2f(model.mapcoord[model.polygon[x].p[1]].u,model.mapcoord[model.polygon[x].p[1]].v);
          glVertex3f(triangle[1][0],triangle[1][1],triangle[1][2]); //Vertex definition

          glTexCoord2f(model.mapcoord[model.polygon[x].p[2]].u,model.mapcoord[model.polygon[x].p[2]].v);
          glVertex3f(triangle[2][0],triangle[2][1],triangle[2][2]); //Vertex definition
          glEnd();
        }
      }
    }else{
      glEnableClientState(GL_VERTEX_ARRAY);                     // activate vertex coords array
      glEnableClientState(GL_COLOR_ARRAY);
   
      glBindBufferARB( GL_ARRAY_BUFFER_ARB , vertexbuffer);    // for vertex coordinates
      glVertexPointer( 3, GL_FLOAT, 0, null );
      glBindBufferARB( GL_ARRAY_BUFFER_ARB , colorbuffer);     // colors
      glColorPointer( 4, GL_UNSIGNED_BYTE, 0, null);
        
        glDrawArrays( GL_TRIANGLES , 0 , 3*npolygons);     //There are 3 times more vertices in memory
  
      glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
  
      glDisableClientState( GL_VERTEX_ARRAY );				        // Disable Vertex Arrays
      glDisableClientState( GL_COLOR_ARRAY );                 //Disable Color arrays
    }
    glPopMatrix();
  }

  bool load(string filename){
    if(!exists(filename) || !isfile(filename)) return false;
    writefln("Opening 3ds-file: %s",filename);
    string materialname = "";
    string objectname   = "";
    string texturename  = "";
    object3ds* model;
    material3ds* material;
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
        if(model!=null) objects ~= (*model);
        model = new object3ds();
        model.name = objectname;
      break; 
      case 0x4100: break; 
      case 0x4110: 
        fread(&l_qty, ushort.sizeof, 1, f);
        model.vertex = new vertextype[l_qty];
        nvertex += l_qty;
        for(uint i=0; i<l_qty; i++){
          fread(&model.vertex[i].v[0], float.sizeof, 1, f);
          fread(&model.vertex[i].v[1], float.sizeof, 1, f);
          fread(&model.vertex[i].v[2], float.sizeof, 1, f);                            
        }
      break; 
      case 0x4120:
        fread(&l_qty,ushort.sizeof, 1, f);
        model.polygon = new polygontype[l_qty];
        npolygons += l_qty;
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
        if(material!=null) materials ~= (*material);
        material = new material3ds();
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
  if(model!=null) objects ~= (*model);
  if(material!=null) materials ~= (*material);
  fp.close();
  writefln("Loaded 3ds-file: %s, %d objects, %d materials",filename, objects.length,materials.length);
  return true;
  }
}
