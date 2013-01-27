module obj.square;
import std.stdio, std.conv, std.file, std.utf, std.string;
import ext.opengl.gl, ext.sdl.sdl;
import objects, window;

class Square : Obj2D{
  this(GLint x, GLint y, GLint sx, GLint sy, GLfloat[4] c = WHITE){
    super(x, y, sx, sy, c);
  }

  override void render(Window w){
    glLoadIdentity();
    glTranslatef(loc[0], loc[1], 0.0);
    glColor4f(color[0], color[1], color[2], color[3]);
    glBegin(GL_QUADS);
      glTexCoord2f(0.0, 0.0); glVertex2i(0, 0);             // top left
      glTexCoord2f(0.0, 1.0); glVertex2i(size[0], 0);       // bottom left
      glTexCoord2f(1.0, 1.0); glVertex2i(size[0], size[1]); // bottom right
      glTexCoord2f(1.0, 0.0); glVertex2i(0, size[1]);       // top right
    glEnd();
  }
}

