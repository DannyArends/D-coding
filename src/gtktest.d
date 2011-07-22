/**
 * \file gtktest.D
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

import std.stdio;
import std.math;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.form;
import gui.gtk.application;
import core.typedefs.types;

void main(string[] args){
  Form myForm = new Form;
  myForm.text("DFL GTK".dup);
  Application.run(myForm);
}

