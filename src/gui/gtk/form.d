/**
 * \file form.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module gui.gtk.form;
 
import std.stdio;
import std.math;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.control;

class Form: Control{
  protected override void createParams(ref CreateParams cp){
    super.createParams(cp);
    with(cp){
      type = gtk_window_get_type();
    }
  }

  protected override void createHandle(){
    if(isHandleCreated) return;
    if(isHandleCreated) return;
    
    CreateParams cp;
    createParams(cp);
    assert(!isHandleCreated);
    wid = gtk_window_new(GtkWindowType.GTK_WINDOW_TOPLEVEL);
    if(!wid){
      throw new Exception("Form creation failure");
    }
    auto win = cast(GtkWindow*)wid;

    gtk_window_set_default_size(win, 300, 300);
    postcreateinit(cp);
  }
}