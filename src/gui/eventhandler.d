module gui.eventhandler;

import core.thread;
import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
import sdl.sdlfunctions;

import gui.engine;
import gui.enginefunctions;

class EventHandler{
public:
  this(Engine engine){
    parent=engine;
    
  }
  
  void call(){
    //while(!parent.isDone()){
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
        case SDL_MOUSEMOTION:
          debug writefln("Mouse moved by %d,%d to (%d,%d)", event.motion.xrel, event.motion.yrel, event.motion.x, event.motion.y);
        break;
        case SDL_MOUSEBUTTONDOWN:
          debug writefln("Mouse button %d pressed at (%d,%d)", event.button.button, event.button.x, event.button.y);  
          getUnproject(event.button.x, event.button.y);
        break;  
        default:
          break;
        }
      }
    //  yield();
    //}
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
        char ch;
        if((keysym.sym & 0xFF80) == 0 ){
          ch = keysym.sym & 0x7F;
          writeln(ch);
        }
      break;
    }
  }
private:
  SDL_Event event;                      /* Used to collect events */
  Engine    parent;                     /* Engine to report to */
}
