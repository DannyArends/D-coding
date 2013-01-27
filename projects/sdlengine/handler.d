import std.stdio, std.conv, std.file, std.utf;
import ext.opengl.gl, ext.sdl.sdl, ext.opengl.glu;
import window, objects;

void checkWidgets(Obj2D[] widgets, int[2] loc){
  foreach(widget; widgets){
    if(loc[0] > widget.x && loc[0] < (widget.x + widget.sx)){
    if(loc[1] > widget.y && loc[1] < (widget.y + widget.sy)){
      widget.onClick(loc[0], loc[1]);
    }}
  }
}

bool handle(ref Window window, SDL_Event event){
  switch(event.type){
    case SDL_VIDEORESIZE:
      window.resize(event.resize.w, event.resize.h);
    break;
    case SDL_QUIT: writefln("SDL_QUIT received");
      return false;
    break;
    case SDL_MOUSEBUTTONDOWN:  /* Fall through switch for all mouse events */
        checkWidgets(window.widgets, [event.button.x, event.button.y]);
    case SDL_MOUSEBUTTONUP:
    case SDL_MOUSEMOTION:
        int    btn    = event.button.button;
        int    loc[2] = [event.button.x, event.button.y];
        int    rel[2] = [event.motion.xrel, event.motion.yrel];
        double pos[3] = unProject(loc);  //writefln("%s -> %s", loc, pos);
    break;
    case SDL_KEYDOWN:          /* Fall through switch for all key events */
    case SDL_KEYUP:
      int keysym = event.key.keysym.sym;
      if((keysym & 0xFF80) == 0 ){
        char c = to!char(keysym & 0x7F);
      }else{ /* Special character */ }
    break;
    default: break;
  }
  return true;
}

double[3] unProject(int[] xy){
  GLint   viewport[4];
  double  model[16];
  double  project[16];
  float   win[3];
  double  pos[3];

  glGetDoublev(GL_MODELVIEW_MATRIX, model.ptr);
  glGetDoublev(GL_PROJECTION_MATRIX, project.ptr);
  glGetIntegerv(GL_VIEWPORT, viewport.ptr);
  win = [cast(float)xy[0], cast(float)viewport[3] - xy[1], 0.0];

  glReadPixels(xy[0], cast(int)win[1], 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &win[2] );
  gluUnProject(win[0], win[1], win[2], model.ptr, project.ptr, viewport.ptr, &pos[0], &pos[1], &pos[2]);
  return pos;
}

