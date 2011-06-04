/**
 * \file glscene.D
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
 * Contains: Hud
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module gui.opengl.glscene;

private import dfl.all;
import std.stdio;
import std.conv;
import gl.gl;
import gl.gl_1_0;
import gui.opengl.glcontrol;
import gui.formats.object3ds;

class Scene{
  GLfloat width;
  GLfloat height;
  model3ds object;
  protected float angley_ = 0.00f;
  protected float anglex_ = 0.00f;  
  
  this(uint w, uint h){
    onResize(w,h);
    object = new model3ds();
    object.load("data/models/humanoid.3ds");
    object.buffer();
  }
  
  void onResize(uint w, uint h){
    width  = cast(GLfloat)w;
    height = cast(GLfloat)h;
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_POLYGON_SMOOTH);
      
    glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
      
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum (-1.0, 1.0, -1.0, 1.0, 1.5, 20.0);
      
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
  }
  
  void render(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glFrustum(-1.0, 1.0, -1.0, 1.0, 1.5, 20.0);
    
    glMatrixMode(GL_MODELVIEW);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glLoadIdentity();
    anglex_ += 2.11;
    angley_ += 4.;
    if (anglex_>360.0) anglex_ -= 360.0f;
    if (angley_>360.0) angley_ -= 360.0f;

    glTranslatef(0.0f, 0.0f, -6.0f);
    glRotatef(angley_, 0.0f,1.0f,0.0f);
    glRotatef(anglex_, 0.1f,0.0f,0.0f);
    glBegin(GL_TRIANGLES);
      glColor3f(0.2,0.5,1.0); glVertex3f( 0.0f, 1.0f, 0.0f);      // Top
      glColor3f(1.0,0.2,0.5); glVertex3f(-1.0f,-1.0f, 0.0f);      // Bottom Left
      glColor3f(0.5,1.0,0.2); glVertex3f( 1.0f,-1.0f, 0.0f);      // Bottom Right
    glEnd();                                                    // Finished Drawing
    object.render();
  }
}
