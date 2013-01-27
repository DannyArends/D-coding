module obj.text2d;
import std.stdio, std.conv, std.file, std.utf, std.string;
import ext.opengl.gl, ext.sdl.sdl;
import objects, window;

class Text2D : Obj2D{
  this(GLint x, GLint y, string line, GLfloat[4] c = WHITE){
    super(x, y, c);
    lines = line.split("\n");
  }

  override void render(Window w){
    foreach(size_t n, string line; lines){
      glLoadIdentity();
      glTranslatef(loc[0], loc[1]+(n*16*scale), 0.0);
      glScalef(scale, scale, scale);
      glColor4f(color[0], color[1], color[2], color[3]);

      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, w.font.id);
      glListBase(w.font.base-32+(128 * w.font.type));
      glCallLists(to!GLint(line.length), GL_UNSIGNED_BYTE, line.dup.ptr);
      glDisable(GL_TEXTURE_2D);
    }
  }

  private:
    GLfloat  scale    = 0.7;
    string[] lines;
}

