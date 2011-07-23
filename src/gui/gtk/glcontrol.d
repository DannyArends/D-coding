/**
 * \file glcontrol.d
 *
 * Button class for gtk, Copyright (c) 2011 Danny Arends
 * 
 **/

module gui.gtk.glcontrol;
 
import std.stdio;
import std.math;
import std.conv;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.control;

class GlControl: Control{

  protected override Size defaultSize(){
    return Size(800, 600);
  }

  protected override void createParams(ref CreateParams cp){
    super.createParams(cp);
  }
	
  alias wid glwid;
}
