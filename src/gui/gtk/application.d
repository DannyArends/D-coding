/**
 * \file application.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module gui.gtk.application;
 
import std.stdio;
import std.math;

import gtk.gtk;
import gtk.gtk_types;
import gui.gtk.form;

class Application{
static:
  void run(Form mainForm){
    if(mainForm){
      mainForm.show();
    }
    gtk_main();
  }

  void run(){
    return run(null);
  }

void exitThread(){
  gtk_main_quit();
  }
}