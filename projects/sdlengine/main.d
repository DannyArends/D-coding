import std.stdio, std.conv, std.file, std.utf, std.string;
import ext.opengl.gl, ext.sdl.sdl;
import objects, window, handler;

void main(string[] args){
  Window    window;                     /* Our window structure */
  SDL_Event event;                      /* SDL event */
  bool      rendering  = true;

  if(SDL_Init(SDL_INIT_VIDEO) < 0) abort(format("Video initialization failed: %s", SDL_GetError()));
  scope(exit) SDL_Quit();
  window.setup("...", "D-Coding - Danny Arends");

  writefln("Renderer = %s", to!string(glGetString(GL_RENDERER)));
  writefln("OpenGL   = %s", to!string(glGetString(GL_VERSION)));
  writefln("Vendor   = %s", to!string(glGetString(GL_VENDOR)));

  glShadeModel(GL_SMOOTH);
  glClearColor(0.0, 0.0, 0.0, 0.0);
  glClearDepth(1.0);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

  while(rendering){
    setupViewport(window.width, window.height);   /* Setup a new viewport       */
    window.render3D();                            /* Render the 3D objects      */
    if(SDL_PollEvent(&event)){
      rendering = window.handle(event);           /* Handle events              */
    }else{ /* No events */ }
    window.render2D();                            /* Render the HUD and widgets */
    SDL_GL_SwapBuffers();
  }
  return;
}

