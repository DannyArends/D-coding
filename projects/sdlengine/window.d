import std.stdio, std.conv, std.file, std.utf, std.string;
import ext.opengl.gl, ext.sdl.sdl;
import texture, objects;

struct Window{
  SDL_Surface*    surface;              /* SDL video surface */
  SDL_VideoInfo*  info;                 /* SDL video information structure */
  Camera          camera;
  Font            font;
  Obj2D[]         widgets;
  Obj3D[]         objects;
  GLsizei width   = 500;
  GLsizei height  = 300;
  int  bpp        = 32;
  int  flags      = SDL_OPENGL;         /* Enable OpenGL in SDL */

  void resize(GLsizei w, GLsizei h){
    width   = w; height  = h;
    surface = SDL_SetVideoMode(w, h, bpp, flags);
  }
  
  void render3D(){
    glLoadIdentity();
    glRotatef(camera.rx, 1.0, 0.0, 0.0);
    glRotatef(camera.ry, 0.0, 1.0, 0.0);
    glRotatef(camera.rz, 0.0, 0.0, 1.0);
    glTranslatef(camera.x,camera.y,camera.z);
    foreach(obj; objects){ obj.render(this); }       /* Render 3D objects */
  }
  void render2D(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, width, height, 0.0f, 0.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glDisable(GL_DEPTH_TEST);
    foreach(obj; objects){ obj.render2D(this); }      /* 2D overlay on 3D objects */
    foreach(widget; widgets){ widget.render(this); }  /* HUD widgets */
  }
}

void setup(ref Window window, string title, string author){
  window.info = SDL_GetVideoInfo();

  if(window.info is null){ abort(format("Video initialization failed: %s", SDL_GetError())); }

  window.flags |= SDL_GL_DOUBLEBUFFER;  /* Enable double buffering */
  window.flags |= SDL_HWPALETTE;        /* Store the palette in hardware */
  window.flags |= SDL_RESIZABLE;        /* Enable window resizing */

  if(window.info.hw_available){ writefln("Video hardware surface available");
    window.flags |= SDL_HWSURFACE;      /* Use a hardware surface */
  }else{ writefln("Video fallback to software surface");
    window.flags|= SDL_SWSURFACE;       /* Use a software surface */
  }
  
  if(window.info.blit_hw){ writefln("Video hardware acceleration available");
    window.flags |= SDL_HWACCEL;        /* Enable hardware acceleration */
  }else{ writefln("No video hardware acceleration available"); }
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);
  window.resize(window.width, window.height);
  if(window.surface is null){ abort(format("Video mode set failed: %s", SDL_GetError())); }
  // Set the window font
  window.font.texture = loadTexture("sdlengine/data/font.png");
  if(window.font.id == -1){ abort(format("Loading opengl font failed: %s", SDL_GetError())); }  
  window.font.base = textureAsFont(window.font.id);
  // Set the window caption
  SDL_WM_SetCaption(toStringz(title), toStringz(author));
/*  window.widgets ~= new Button(100, 100, 30, 10, &echoname, GREEN);
  window.widgets ~= new Text2D(0, 0, "Danny Arends\nJust trying");
  for(auto x = 1; x < 10; x++){
  for(auto z = 1; z < 10; z++){
    window.objects ~= new Quad(x, 0.0, z);
  }} */
}

void setupViewport(GLsizei width, GLsizei height, GLfloat near = 1.0, GLfloat far = 1000.0){
  if(width  <= 0) width  = 1;
  if(height <= 0) height = 1;
  GLfloat ratio = cast(GLfloat)height / cast(GLfloat)width;
  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glFrustum(-1.0, 1.0, -ratio, ratio, near, far);
  glMatrixMode(GL_MODELVIEW);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  glEnable(GL_DEPTH_TEST);
  glLoadIdentity();
}

