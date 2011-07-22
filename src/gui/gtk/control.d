/**
 * \file control.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module gui.gtk.control;
 
import std.stdio;
import std.math;

import gtk.gtk;
import gtk.gtk_types;

class Control{

  final HWindow handle(){
    if(!isHandleCreated){
      printf("Control created due to handle request.\n");
      createHandle();
    }
    return wid;
  }

  protected Size defaultSize(){
    return Size(0, 0);
  }

  // Force creation of the window and its child controls.
  final void createControl(){
    createHandle();
    createChildren();
  }
  
  final void createChildren(){ }

  protected GtkContainer* gtkGetContainer(bool autoCreate = true){
    if(wcontainer) return wcontainer;
    if(!autoCreate) return null;

    if(!isHandleCreated){
      throw new Exception("Handle must be created before getting container (gtkGetContainer)");
    }
    wcontainer = cast(GtkContainer*)gtk_fixed_new();
    gtk_container_add(cast(GtkContainer*)wid, cast(GtkWidget*)wcontainer);
    gtk_widget_realize(cast(GtkWidget*)wcontainer);
    gtk_widget_show(cast(GtkWidget*)wcontainer);
    return wcontainer;
  }
  
  // Override to change the creation parameters.
  // Be sure to call super.createParams() or all the create params will need to be filled.
  protected void createParams(ref CreateParams cp){
    with(cp){
      type = gtk_widget_get_type();
      parent = null;
      if(wparent){
        parent = wparent.gtkGetContainer();
      }
      text = wtext;
    }
  }

  protected void createHandle(){
    if(isHandleCreated) return;
    if(wparent) wparent.createHandle();
    if(isHandleCreated) return;

    CreateParams cp;
    createParams(cp);
    assert(!isHandleCreated); // Make sure the handle wasn't created in createParams().
    
    wid = gtk_widget_new(cp.type, null);
    if(!wid){
      throw new Exception("Control creation failure");
    }
    gtk_widget_set_size_request(wid, defaultSize.width, defaultSize.height);
    postcreateinit(cp);
  }


  void postcreateinit(ref CreateParams cp){
    if(!(ctrlStyle & ControlStyles.CACHE_TEXT)) wtext = null;
    gtkSetTextCore(cp.text);

    if(cp.parent){
      gtk_container_add(cp.parent, wid);
    }
    gtk_widget_realize(wid);
    gtk_widget_show(wid);
  }

  protected void gtkSetTextCore(char[] txt){
    wtext = txt;
  }

  protected char[] gtkGetTextCore(){
    return wtext;
  }

  void text(char[] txt){
    if(isHandleCreated){
      gtkSetTextCore(txt);
      if(ctrlStyle & ControlStyles.CACHE_TEXT) wtext = txt;
    }else{
      wtext = txt;
    }
  }

  char[] text(){
    if(isHandleCreated){
      if(ctrlStyle & ControlStyles.CACHE_TEXT) return wtext;
      return gtkGetTextCore();
    }else{
      return wtext;
    }
  }

  final void parent(Control c){
    wparent = c;
  }

  final Control parent(){
    return wparent;
  }

  final bool isHandleCreated(){
    return wid != wid.init;
  }

  final bool areChildrenCreated(){
    return isHandleCreated;
  }

  final bool created(){
    return isHandleCreated && areChildrenCreated;
  }

  final void hide(){ }
  
  final void show(){ 
    createControl();
  }

  protected:
    GtkWidget* wid;
    GtkContainer* wcontainer;
    Control wparent;
    char[] wtext;
    ControlStyles ctrlStyle = ControlStyles.STANDARD_CLICK | ControlStyles.STANDARD_DOUBLE_CLICK;
}