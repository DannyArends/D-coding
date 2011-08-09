module gui.objects.surface;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import core.typedefs.types;

import gui.objects.camera;
import gui.objects.color;
import gui.objects.object3d;

class Surface : Object3D{
  
  this(double x, double y, double z, int size_x = 100, int size_z = 100){
    super(x,y,z);
    heightmap = newmatrix!double(size_x,size_z);
    colormap = newclassmatrix!Color(size_x,size_z);
    this.size_x = size_x;
    this.size_z = size_z;
    setSize(0.5,0.0,0.5);
  }
  
  void render(Camera camera){
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y-y(),camera.z-z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    glBegin(GL_QUADS);
    for(uint x=0; x < size_x;x++){
      for(uint z=0; z < size_z;z++){
        glColor4f(colormap[x][z].r(),colormap[x][z].g(),colormap[x][z].b(),colormap[x][z].alpha());
        glVertex3f(x+sx(), heightmap[x][z],z+sz() );
        glVertex3f(x-sx(), heightmap[x][z],z+sz() );
        glVertex3f(x-sx(), heightmap[x][z],z-sz() );
        glVertex3f(x+sx(), heightmap[x][z],z-sz() );
      }
    }
    glEnd();
  }
  
private:
  uint size_x;
  uint size_z;
  dmatrix  heightmap;
  Color[][] colormap;
};