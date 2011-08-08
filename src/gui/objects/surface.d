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
  
  this(double x, double y, double z, int size_x = 20, int size_y = 20){
    super(x,y,z);
    heightmap = newmatrix!double(size_x,size_y);
    colormap = newclassmatrix!Color(size_x,size_y);
    this.size_x = size_x;
    this.size_y = size_y;
    setSize(0.1,0.1,0.1);
  }
  
  void render(Camera camera){
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y-y(),camera.z-z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    glBegin(GL_QUADS);
      for(uint x=0; x < size_x;x++){
        for(uint y=0; y < size_y;y++){
          glColor4f(colormap[x][y].r(),colormap[x][y].g(),colormap[x][y].b(),colormap[x][y].alpha());
          glVertex3f(x+sx(), heightmap[x][y],y+sy() );
          glVertex3f(x-sx(), heightmap[x][y],y+sy() );
          glVertex3f(x-sx(), heightmap[x][y],y-sy() );
          glVertex3f(x+sx(), heightmap[x][y],y-sy() );
        }
      }
    glEnd();
  }
private:
  uint size_x;
  uint size_y;
  dmatrix  heightmap;
  Color[][] colormap;
};