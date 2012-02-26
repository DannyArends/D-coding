module gui.hudhandler;

import std.array;
import std.stdio;
import std.conv;

import core.typedefs.types;
import io.events.engine;
import io.events.mouseevent;

import game.engine;

import gui.screen;
import gui.enginefunctions;
import gui.widgets.object2d;
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
            break;
            default:
            break;
          }
        }else{
          double[3] loc = evt.getXYZ();
          writeln("S:" ~ to!string(evt.sx) ~ ";" ~ to!string(evt.sy));
        }
      }
    }
    
  private:
    Screen      screen;
}
