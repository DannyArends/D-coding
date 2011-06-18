/**
 * \file gltimer.D
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
 * Contains: glTimer
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module gui.opengl.gltimer;
 
private import dfl.all;
import std.stdio;
import std.conv;
import gui.opengl.glcontrol;

class glTimer: Timer{
  private GLControl glc;
  this (uint fps, GLControl glc){
    this.glc = glc;
    this.interval = 1000/fps;
  }
    
  override void onTick(EventArgs ea){
    glc.invalidate();
  }
}