/**
 * \file menu.d
 *
 * Menu class for gtk, Copyright (c) 2011 Danny Arends
 * 
 **/

module gui.gtk.menu;
 
import std.stdio;
import std.math;
import std.conv;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.control;

class Menu : Control{

  protected override Size defaultSize(){
    return Size(150, 23);
  }

  protected override void createParams(ref CreateParams cp){
    super.createParams(cp);
  }
	
  alias wid menuwid;
}

