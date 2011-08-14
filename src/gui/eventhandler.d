module gui.eventhandler;

import core.thread;
import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;
import sdl.sdlfunctions;

import gui.engine;
import gui.enginefunctions;

import gui.widgets.object2d;
import gui.widgets.button;
import gui.widgets.textinput;

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
          parent.getHud().resize(event.resize.w, event.resize.h);
          break;
        case SDL_KEYDOWN:
          handleKeyPress(&event.key.keysym);
          break;
        case SDL_QUIT:
          parent.isDone(true);
          break;
        case SDL_MOUSEMOTION:
          debug writefln("Mouse moved by %d,%d to (%d,%d)", event.motion.xrel, event.motion.yrel, event.motion.x, event.motion.y);
          if(monitoring_drag !is null) monitoring_drag.onDrag(event.motion.xrel, event.motion.yrel);
        break;
        case SDL_MOUSEBUTTONDOWN:
          debug writefln("Mouse button %d pressed at (%d,%d)", event.button.button, event.button.x, event.button.y);
          Object2D hit = parent.getHud().getObjectAt(event.button.x, event.button.y);
          if(hit !is null && !hit.isHud()){
            switch(hit.getType){
              case Object2DType.TEXTINPUT:
                monitoring_keys = cast(TextInput)(hit);
              break;
              case Object2DType.BUTTON:
                (cast(Button)(hit)).onClick();
              break;
              case Object2DType.DRAGBAR:
                monitoring_drag = cast(DragBar)(hit);
                monitoring_drag.onClick();
              break;
              default:
                monitoring_keys = parent.getHud().getHudText();
                monitoring_drag = null;
                writefln("You hit: %d [%d,%d]",hit.getType, to!int(hit.x()), to!int(hit.y()));  
              break;
            }
          }else{
            monitoring_keys = parent.getHud().getHudText();
            monitoring_drag = null;
            double[3] loc = getUnproject(event.button.x, event.button.y);
            parent.getNetworkclient().send("M:" ~ to!string(loc));
          }
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
          if(monitoring_keys !is null){
            monitoring_keys.handleKeyPress(keysym.sym);
          }
          writeln(ch);
        }
      break;
    }
  }
private:
  TextInput monitoring_keys;
  DragBar   monitoring_drag;
  SDL_Event event;                      /* Used to collect events */
  Engine    parent;                     /* Engine to report to */
}
