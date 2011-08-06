/**
 * \file gtktest.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;

import gui.window;

void main(string[] args){
  SimpleWindow w = new SimpleWindow(800,600,"Test");
  w.eventLoop(20);
}

