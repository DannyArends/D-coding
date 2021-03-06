/******************************************************************//**
 * \file src/gui/objects/model3ds.d
 * \brief 3DS object definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.objects.model3ds;

import std.array, std.stdio, std.conv;
import gl.gl_1_0, gl.gl_1_1, gl.gl_1_5, gl.gl_ext;
import gui.objects.object3d;
import gui.formats.o3ds;

/*! \brief Wrapper to render a 3DS model
 *
 *  Wrapper to render a 3DS model
 */
class Model3DS : Object3D{
public:  
  this(string filename){ this(0,0,0,filename); }
  
  this(double x, double y, double z,string filename){
    super(x,y,z);
    model = loadModelInfo3DS(filename);
  }
  
  override void buffer(){ bufferModelInfo3DS(model); }
  
  override void render(int faceType = GL_TRIANGLES){
    glToLocation();
    if(model.buffered){
      glEnableClientState(GL_VERTEX_ARRAY);                     // activate vertex coords array
      glEnableClientState(GL_COLOR_ARRAY);
   
      glBindBufferARB(GL_ARRAY_BUFFER_ARB , model.vertexbuffer);    // for vertex coordinates
      glVertexPointer(3, GL_FLOAT, 0, null );
      glBindBufferARB(GL_ARRAY_BUFFER_ARB , model.colorbuffer);     // colors
      glColorPointer(4, GL_UNSIGNED_BYTE, 0, null);
        
      glDrawArrays(GL_TRIANGLES , 0 , 3*model.npolygons);     //There are 3 times more vertices in memory
  
      glBindBufferARB(GL_ARRAY_BUFFER_ARB, 0);
  
      glDisableClientState( GL_VERTEX_ARRAY );                // Disable Vertex Arrays
      glDisableClientState( GL_COLOR_ARRAY );                 //Disable Color arrays
    }else{
      glColor4f(r(), g(),  b(), alpha());
      foreach(Object3DS o3d;model.objects){
        int polygons = 0;
        for(size_t x=0; x < o3d.polygon.length; x++){
          glBegin(faceType);
          
          glNormal3f(model.normals[polygons][0], model.normals[polygons][1], model.normals[polygons][2]);
          glTexCoord2f(o3d.mapcoord[o3d.polygon[x].p[0]].u,o3d.mapcoord[o3d.polygon[x].p[0]].v);
          glVertex3f(
              o3d.vertex[o3d.polygon[x].p[0]].v[0],
              o3d.vertex[o3d.polygon[x].p[0]].v[1],
              o3d.vertex[o3d.polygon[x].p[0]].v[2]); //Vertex definition
  
          glTexCoord2f(o3d.mapcoord[o3d.polygon[x].p[1]].u,o3d.mapcoord[o3d.polygon[x].p[1]].v);
          glVertex3f(
              o3d.vertex[o3d.polygon[x].p[1]].v[0],
              o3d.vertex[o3d.polygon[x].p[1]].v[1],
              o3d.vertex[o3d.polygon[x].p[1]].v[2]); //Vertex definition
  
          glTexCoord2f(o3d.mapcoord[o3d.polygon[x].p[2]].u,o3d.mapcoord[o3d.polygon[x].p[2]].v);
          glVertex3f(
              o3d.vertex[o3d.polygon[x].p[2]].v[0],
              o3d.vertex[o3d.polygon[x].p[2]].v[1],
              o3d.vertex[o3d.polygon[x].p[2]].v[2]); //Vertex definition
          glEnd();
  
          polygons++;
        }
      }
    }
  }
  
  override int getFaceType(){ return GL_TRIANGLES; }
  
  private:
    ModelInfo3DS* model;
}
