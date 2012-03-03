module gui.hudhandler;

import std.array;
import std.stdio;
import std.conv;

import sdl.sdlstructs;


import core.typedefs.types;
import io.events.engine;
import io.events.mouseevent;
import io.events.keyevent;
import game.engine;
import gui.screen;
import gui.enginefunctions;
import gui.widgets.object2d;
import gui.widgets.textinput;
import gui.widgets.button;

class HudHandler : EventHandler{
  public:    
    this(Screen screen){
      this.screen = screen;
    }
    
    void handle(Event e){
      if(e is null) return;
      if(e.getEventType() == EventType.MOUSE){
        MouseEvent evt = cast(MouseEvent) e;
        Object2D hit = screen.getObjectAt(evt.sx, evt.sy);
        if(hit !is null && !hit.isScreen()){
          switch(hit.getType){
            case Object2DType.BUTTON:
              (cast(Button)(hit)).onClick(evt.sx, evt.sy);
              e.handled = true;
            break;
            case Object2DType.TEXTINPUT:
              keyhandler = cast(TextInput)(hit);
              e.handled = true;
            break;
            default:
            break;
          }
        }else{
          double[3] loc = evt.getXYZ();
          //writeln("S:" ~ to!string(evt.sx) ~ ";" ~ to!string(evt.sy));
        }
      }
      if(e.getEventType() == EventType.KEYBOARD){
        KeyEvent key = cast(KeyEvent) e;
        if(key.getSDLkey() == SDLK_RSHIFT || key.getSDLkey() == SDLK_LSHIFT){
          shiftStatus = false;
          if(key.getKeyEventType() == KeyEventType.DOWN){
            shiftStatus = true;
          }
        }else{
          if(key.getKeyEventType() == KeyEventType.DOWN){
            key.setShift(shiftStatus);
            if(keyhandler !is null) keyhandler.handleKeyPress(key);
          }
        }
      }
    }
    
  private:
    Screen      screen;
    TextInput   keyhandler;
    bool        shiftStatus;
}
