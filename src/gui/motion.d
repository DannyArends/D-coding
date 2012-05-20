/******************************************************************//**
 * \file src/gui/motion.d
 * \brief Abstract concept of object motion
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.motion;

import std.array;
import std.stdio;
import std.math;
import std.conv;

import sdl.sdlstructs;

import core.typedefs.types;
import core.typedefs.camera;
import core.events.engine;
import core.events.keyevent;
import core.events.mouseevent;
import gui.screen;
import gui.objects.object3d;

class CameraMotion : EventHandler{ 
  this(Screen screen){ scr = screen; }
  
  @property Screen screen(){ return scr; }
  private:
  Screen scr;
}

class NoMotion : CameraMotion {
  this(){ super(null); }  
  override void handle(Event e){ }
}

class FPMotion : CameraMotion {
  this(Screen screen){ super(screen); }
  
  override void handle(Event e){
    if(e.getEventType() == EventType.KEYBOARD){
      KeyEvent evt = cast(KeyEvent)e;
      switch(evt.getSDLkey()){
        case SDLK_UP:
          screen().getCamera().move([0,0,2]);
          e.handled=true;
          break;
        case SDLK_DOWN:
          screen.getCamera().move([0,0,-2]);
          e.handled=true;
          break;
        case SDLK_PAGEUP:
          screen.getCamera().move([0,2,0]);
          e.handled=true;
          break;
        case SDLK_PAGEDOWN:
          screen.getCamera().move([0,-2,0]);
          e.handled=true;
          break;
        case SDLK_LEFT:
          screen.getCamera().move([-2,0,0]);
          e.handled=true;
          break;
        case SDLK_RIGHT:
          screen.getCamera().move([2,0,0]);
          e.handled=true;
          break;
        default: break;
        }
        writefln("[MOV] KeyBOARD %s",evt.getSDLkey());
      }
    }
  }

class ObjectMotion : CameraMotion {
  this(Screen screen, Object3D object, double distance = 20){ 
    super(screen);
    this.object=object;
    this.distancetotarget=distance;
  }
  
  override void handle(Event e){
    if(e.getEventType() == EventType.KEYBOARD){
      KeyEvent k_evt = cast(KeyEvent)e;
      switch(k_evt.getSDLkey()){
        case SDLK_UP:
          object.move([0,0,2]);
          e.handled=true;
          break;
        case SDLK_DOWN:
          object.move([0,0,-2]);
          e.handled=true;
          break;
        case SDLK_PAGEUP:
          screen.getCamera().rotate([-2,0,0]);
          e.handled=true;
          break;
        case SDLK_PAGEDOWN:
          screen.getCamera().rotate([2,0,0]);
          e.handled=true;
          break;
        case SDLK_LEFT:
          object.move([-2,0,0]);
          e.handled=true;
          break;
        case SDLK_RIGHT:
          object.move([2,0,0]);
          e.handled=true;
          break;
        case SDLK_EQUALS:
          distancetotarget++;
          e.handled=true;
          break;      
        case SDLK_MINUS:
          distancetotarget--;
          e.handled=true;
          break;
        default: break;
      }
      writefln("[MOV] KeyBOARD %s",k_evt.getSDLkey());
    }
    if(e.getEventType() == EventType.MOUSE){
      MouseEvent m_evt = cast(MouseEvent) e;
      switch(m_evt.getBtn()){
        case MouseBtn.RIGHT:
          dragging=!dragging;
          e.handled=true;
        break;
        default: 
        if(dragging){
          screen.getCamera().rotate([2*m_evt.syr,2*m_evt.sxr,0]);
          update();
          e.handled=true;
        }
        break;
      }
    }
  }
  
  override void update(){
    double loc[3] = object.location;
    Camera c = screen.getCamera();
    int h_rot = cast(int)c.direction[0];
    int v_rot = cast(int)c.direction[1]+90;
    float cameramod = distancetotarget*cos((h_rot*PI)/180);
    loc[0] += cameramod*(cos((v_rot*PI)/180));
    loc[1] += distancetotarget*sin((h_rot*PI)/180);
    loc[2] += cameramod*(sin((v_rot*PI)/180));
    c.location = [-loc[0],-loc[1],-loc[2]];
  }
  
  private:
    double     distancetotarget = 20;
    Object3D   object;
    bool       dragging=false;
}
