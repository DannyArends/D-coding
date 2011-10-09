module gui.objects.surface;

import std.array;
import std.stdio;
import std.conv;

import gl.gl_1_0;

import core.typedefs.types;

import gui.objects.camera;
import gui.objects.color;
import gui.objects.object3d;
import gui.formats.tga;

class Surface : Object3D{
  
  this(double x, double y, double z, int size_x = 100, int size_z = 100){
    super(x,y,z);
    heightmap = newmatrix!double(size_x,size_z);
    colormap = newclassmatrix!Color(size_x,size_z);
    this.size_x = size_x;
    this.size_z = size_z;
  }
  
  this(double x, double y, double z, tgaInfo texture){
    super(x,y,z);
    heightmap = newmatrix!double(texture.width,texture.height);
    colormap = asColorMap(texture);
    this.size_x = texture.width;
    this.size_z = texture.height;
    auto my = 0;
    auto mx = 0;
  }
  
  void addObject(int x, int z, Object3D object){
    object.setLocation(x,heightmap[x][z],z);
    objects ~= object;
  }
  
  void render(Camera camera, int faceType = GL_TRIANGLE_STRIP) {
    glLoadIdentity();
    glTranslatef(camera.x+x(),camera.y+y(),camera.z+z());

    glRotatef(camera.rx+rx(), 1.0, 0.0, 0.0);
    glRotatef(camera.ry+ry(), 0.0, 1.0, 0.0);
    glRotatef(camera.rz+rz(), 0.0, 0.0, 1.0);
    
    for(int i = 0 ; i < size_x-1; i++) {
      glBegin(faceType);
      for(int j=0; j < size_z; j++) {
        glColor4f(colormap[i][j].r(),colormap[i][j].g(),colormap[i][j].b(),colormap[i][j].alpha());
        glVertex3f(i*sx(),heightmap[i][j],j*sz());
        glColor4f(colormap[i+1][j].r(),colormap[i+1][j].g(),colormap[i+1][j].b(),colormap[i+1][j].alpha());
        glVertex3f((i+1)*sx(),heightmap[i+1][j],j*sz());
      }
      glEnd();
    }
    foreach(Object3D o; objects){
      o.render(camera);
    }
  }
  
  int getFaceType(){ return GL_TRIANGLE_STRIP; }
  
private:
  int size_x;
  int size_z;
  dmatrix      heightmap;
  Color[][]    colormap;
  Object3D[]   objects;
}
