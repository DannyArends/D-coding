module obj.quad;
import std.stdio, std.conv, std.file, std.utf, std.string;
import ext.opengl.gl, ext.sdl.sdl;
import objects, window;

class Quad : Obj3D{
  this(GLfloat x,GLfloat y,GLfloat z){ loc = [x, y, z]; }

  override void render(Window w){
    glPushMatrix();
    glTranslatef(loc[0], loc[1], loc[2]);
    glRotatef(rot[0], 1.0, 0.0, 0.0);
    glRotatef(rot[1], 0.0, 1.0, 0.0);
    glRotatef(rot[2], 0.0, 0.0, 1.0);
    glColor4f(color[0], color[1], color[2], color[3]);
    glBegin(GL_QUADS);
      glTexCoord2f(1.0, 1.0);
      glVertex3f(size[0], size[1], 0.0f );
      glTexCoord2f(0.0, 1.0);
      glVertex3f(0,  size[1], 0.0f );
      glTexCoord2f(0.0, 0.0);
      glVertex3f(0,  0,  0.0f );
      glTexCoord2f(1.0, 0.0);
      glVertex3f(size[0], 0,  0.0f );
    glEnd();
    glPopMatrix();
  }
  override void render2D(Window w){ }

  private:
    GLfloat size[2] = [0.1, 0.1];
}

