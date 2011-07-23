/**
 * \file button.d
 *
 * Button class for gtk, Copyright (c) 2011 Danny Arends
 * 
 **/

module gui.gtk.button;
 
import std.stdio;
import std.math;
import std.conv;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.control;

class Button: Control{

  this(Location l){
    super(l, defaultSize());
  }

  protected override Size defaultSize(){
    return Size(150, 23);
  }

  protected override void coreSetText(string txt){
    gtk_button_set_label(cast(GtkButton*)buttonwid, txt.dup.ptr);
  }

  protected override void createParams(ref CreateParams cp){
    super.createParams(cp);
    with(cp){
        type = gtk_hbox_get_type();
    }
  }

  package override void postcreateinit(ref CreateParams cp){
    buttonwid = gtk_widget_new(gtk_button_get_type(), null);
    super.postcreateinit(cp);
    gtk_box_pack_start(cast(GtkBox*)wid, buttonwid, false, false, 0);
    gtk_widget_realize(buttonwid);
    gtk_widget_show(buttonwid);
  }
	
  GtkWidget* buttonwid;
}
