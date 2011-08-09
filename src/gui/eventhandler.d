module gui.eventhandler;

import core.thread;
import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
import sdl.sdlfunctions;

import gui.engine;
import gui.enginefunctions;

class EventHandler : Fiber{
public:
  this(Engine engine){
    parent=engine;
    super(&run);
  }
  
  void run(){
    while(!parent.isDone()){
      while(SDL_PollEvent(&event)){
        switch(event.type){
        case SDL_ACTIVEEVENT:
          if(event.active.gain == 0){
            parent.isActive(false);
          }else{
            parent.isActive(true);
          }
          break;          
        case SDL_VIDEORESIZE:
          parent.setSurface(event.resize.w,event.resize.h);
          if(parent.getSurface() is null){
            writefln("Video surface resize failed: %s", to!string(SDL_GetError()));
            return;
          }
          resizeWindow(event.resize.w, event.resize.h);
          break;
        case SDL_KEYDOWN:
          handleKeyPress(&event.key.keysym);
          break;
        case SDL_QUIT:
          parent.isDone(true);
          break;
        default:
          break;
        }
      }
      yield();
    }
  }
  
  void handleKeyPress(SDL_keysym *keysym){
    switch(keysym.sym){
      case SDLK_F1:
        SDL_WM_ToggleFullScreen(parent.getSurface());
      break;
      case SDLK_UP:
        parent.getCamera().move(0,0,2);
        break;
      case SDLK_DOWN:
        parent.getCamera().move(0,0,-2);
        break;
      case SDLK_PAGEUP:
        parent.getCamera().move(0,2,0);
        break;
      case SDLK_PAGEDOWN:
        parent.getCamera().move(0,-2,0);
        break;           
      case SDLK_LEFT:
        parent.getCamera().move(-2,0,0);
        break; 
      case SDLK_RIGHT:
        parent.getCamera().move(2,0,0);
        break;
      case SDLK_ESCAPE:
        parent.isDone(true);
      break;         
      default:
      break;
    }
  }
private:
  SDL_Event event;                      /* Used to collect events */
  Engine    parent;                     /* Engine to report to */
}
