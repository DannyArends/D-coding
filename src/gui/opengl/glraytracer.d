/**
 * \file glraytracer.D
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
 * Contains: Raytracer
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module gui.opengl.glraytracer;

private import dfl.all;
import std.stdio;
import std.conv;
import std.datetime;
import std.random;
import core.time;

import gl.gl;
import gl.gl_1_0;
import gui.opengl.glcontrol;
import gui.formats.object3ds;
import core.arrays.ray;

class Raytracer{
  GLfloat width;
  GLfloat height;
  camera cameraobject;
  world worldcoords;
  
  this(uint w, uint h){
    onResize(w,h);
  }
  
  void onResize(uint w, uint h){
    width  = cast(GLfloat)w;
    height = cast(GLfloat)h;
    cameraobject.width=w;
    cameraobject.width=w;
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, width, height, 0.0f, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
  }
  
  void render(){
    glBegin(GL_POINTS);
    auto t0 = Clock.currTime();
    auto t1 = Clock.currTime();
    while((t1-t0).fracSec().msecs() < 190){
    	int y = uniform(0, cast(int)height);
			int x = uniform(0, cast(int)width);
      auto ray = constructRayThroughPixel(worldcoords,cameraobject,x,y);
      glColor3f(x/width, y/height, 0.0f);
      glVertex2f(x, y);
      t1 = Clock.currTime();
    }
    glEnd();
  }
}
