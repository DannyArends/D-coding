/**
 * \file label.d
 *
 * Based on DFL gtk version, Copyright (c) 2011 Danny Arends
 * 
 **/

module gui.gtk.label;
 
import std.stdio;
import std.math;
import std.conv;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.control;

//version = GTK_LABEL_BOX;

class Label : Control{

  this(Location l){
    super(l, defaultSize());
  }

  protected override Size defaultSize(){
    return Size(150, 23);
  }

  protected override void createParams(ref CreateParams cp){
    super.createParams(cp);
    with(cp){
      version(DFLGTK_LABEL_BOX){
        type = gtk_hbox_get_type();
      }else{
        type = gtk_label_get_type();
      }
    }
  }

  protected override void coreSetText(string txt){
    gtk_label_set_text(cast(GtkLabel*)labelwid, txt.dup.ptr);
  }

  protected override string coreGetText(){
    string result = to!string(gtk_label_get_text(cast(GtkLabel*)labelwid));
    if(!result.length) return "";
    return result;
  }

  package override void postcreateinit(ref CreateParams cp){
    version(GTK_LABEL_BOX){
      labelwid = gtk_widget_new(gtk_label_get_type(), null);
      if(!labelwid){
        throw new Exception("Failed to create label control");
      }
    }
    gtk_misc_set_alignment(cast(GtkMisc*)labelwid, 0.0, 0.0);
    super.postcreateinit(cp);
    version(GTK_LABEL_BOX){
      gtk_box_pack_start(cast(GtkBox*)wid, labelwid, false, false, 0);
      gtk_widget_realize(labelwid);
      gtk_widget_show(labelwid);
    }
  }
	
  alias wid labelwid;
}

