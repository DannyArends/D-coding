/**
 * \file glengine.D
 *
 * last modified Jun, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: RenderingEngine
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module gui.opengl.glengine;

private import dfl.all;
import std.stdio;
import std.conv;
import gl.gl;
import gl.gl_1_0;
import gui.opengl.glcontrol;
import gui.opengl.glscene;
import gui.opengl.glhud;

class RenderingEngine : GLControl{
  Scene screen;
  Hud hud;
  
  this(){
  }
  
  protected:
    override void onResize(EventArgs ea){
      makeCurrent();
      glViewport(0, 0, bounds.width, bounds.height);
      screen.onResize(bounds.width, bounds.height);
      hud.onResize(bounds.width, bounds.height);
      debug writefln("Resized to: %d %d, error: %s",bounds.width, bounds.height,to!string(glGetError()));
      invalidate();
    }

    override void initGL() {
      glClearColor(1.0f,1.0f,0.3f,0.0f);
      screen = new Scene(bounds.width, bounds.height);
      hud = new Hud(bounds.width, bounds.height);
    }

    override void render(){
      screen.render();
      hud.render();
      swapBuffers();
    }
}