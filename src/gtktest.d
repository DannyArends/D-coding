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
import gui.gtk.label;
import gui.gtk.application;
import core.typedefs.types;

void main(string[] args){
  Form myForm = new Form;
  Label myLabel = new Label(Location(100,10));

  myLabel.text = "Hello, GTK+ World!";
  myLabel.parent = myForm;
  myForm.text("D 2.0 GTK+ Binding");
  Application.run(myForm);
}

