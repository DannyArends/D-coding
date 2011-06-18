/**
 * \file glhud.D
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
 
module gui.opengl.glhud;

private import dfl.all;
import std.stdio;
import std.conv;
import gl.gl;
import gl.gl_1_0;
import gl.gl_1_1;
import gui.opengl.glcontrol;
import gui.formats.tga;

class Hud{
  GLfloat width;
  GLfloat height;
  uint fontbase;
  TGA font;
  
  this(uint w, uint h){
    onResize(w,h);
    font = new TGA();
    font.load("data/fonts/font.tga");
    fontbase = font.loadAsFont();
  }
  
  void onResize(uint w, uint h){
    width  = cast(GLfloat)w;
    height = cast(GLfloat)h;
  }
  
  GLvoid glprint(GLint x, GLint y, uint base, int set, string toprint){
    if (set>1) set=1;
    if (set<0) set=0;
    
    glLoadIdentity();
    glEnable(GL_TEXTURE_2D);						
    glTranslated(x,y,0);								
    glListBase(base-32+(128*set));
    glScalef(1.0f,1.0f,1.0f);
    glColor3f(1.0f, 1.0f, 1.0f);
    glCallLists(toprint.length,GL_UNSIGNED_BYTE, &toprint.dup[0]);
    glDisable(GL_TEXTURE_2D);
    glLoadIdentity();
  }
  
  void render(){
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(0.0f, width, height, 0.0f, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, font.info.textureID[0]);
    glLoadIdentity();
    glprint(20,20,fontbase,0,"Testing the HUD");
    glDisable(GL_TEXTURE_2D);
  }
}
