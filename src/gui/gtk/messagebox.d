/**
 * \file messagebox.d
 *
 * messagebox class for gtk, Copyright (c) 2011 Danny Arends
 * 
 **/

module gui.gtk.messagebox;
 
import std.stdio;
import std.math;
import std.conv;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.control;

class MessageBox : Control{

  protected override Size defaultSize(){
    return Size(400, 200);
  }

  protected override void createParams(ref CreateParams cp){
    super.createParams(cp);
  }
	
  alias wid messageboxwid;
}
