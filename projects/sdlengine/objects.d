import std.stdio, std.conv, std.file, std.utf, std.string, std.c.stdlib;
import ext.opengl.gl, ext.sdl.sdl;
import window;
public import obj.text2d, obj.quad, obj.square, obj.button;

enum ObjTYPE : string { O2D = "O2D", O3D = "O3D" };
enum BtnTYPE { LEFT, MIDDLE, RIGHT };
enum ClickTYPE { UP, DOWN };

immutable GLfloat[4]
  WHITE  = [1.0, 1.0, 1.0, 1.0], 
  RED    = [1.0, 0.0, 0.0, 1.0],
  YELLOW = [1.0, 1.0, 0.0, 1.0],
  GREEN  = [0.0, 1.0, 0.0, 1.0],
  LBLUE  = [0.0, 1.0, 1.0, 1.0],
  BLUE   = [0.0, 0.0, 1.0, 1.0],
  GRAY50 = [0.5, 0.5, 0.5, 1.0],
  BLACK  = [0.0, 0.0, 0.0, 1.0];

abstract class Obj(T){
  abstract void render(Window w);

  T child(size_t i){ return children[i]; }
  @property T parent(T p){ if(p !is null){ _parent = p; } return _parent; }

  protected:
    T   _parent;
    T[] children;
}

abstract class Obj2D : Obj!Obj2D{ 
  this(GLint x = 0, GLint y = 0, GLfloat[4] c = WHITE){
    this(x,y, 0, 0,c);
  }
  this(GLint x = 0, GLint y = 0, GLint sx = 0, GLint sy = 0, GLfloat[4] c = WHITE){
    loc   = [x, y];
    size  = [sx, sy];
    color = c;
  }
  abstract void render(Window w);

  void onClick(GLint x, GLint y){}
  void onDrag(GLint x, GLint y){}
  
  @property int x(){  return loc[0]; }
  @property int y(){  return loc[1]; }
  @property int sx(){ return size[0]; }
  @property int sy(){ return size[1]; }

  protected:
    GLint   loc[2]   = [0, 0];
    GLint   size[2]  = [0, 0];
    GLfloat color[4] = WHITE;
}

abstract class Obj3D : Obj!Obj3D{
  abstract void render(Window w);
  abstract void render2D(Window w);

  protected:
    GLfloat loc[3]   = [0.0, 0.0, 0.0];
    GLfloat rot[3]   = [0.0, 0.0, 0.0];
    GLfloat color[4] = WHITE;
}

struct Texture{
  GLint   id, width, height, bpp, type;
  ubyte[] data;
}

struct Font{
  @property GLint id(GLint id = -1){
    if(id != -1){ texture.id = id; }
    return texture.id;
  }

  Texture texture;
  GLint   base;
  GLint   type = 0;
}

struct Camera{
  @property GLfloat x(){ return location[0]; }
  @property GLfloat y(){ return location[1]; }
  @property GLfloat z(){ return location[2]; }

  @property GLfloat rx(){ return rotation[0]; }
  @property GLfloat ry(){ return rotation[1]; }
  @property GLfloat rz(){ return rotation[2]; }
  
  GLfloat location[3] = [-1.5, 0.0, -6.0];
  GLfloat rotation[3] = [0.0, 0.0, 0.0];
}

void abort(string s){
  stderr.writeln(s);
  exit(-1);
}

