/**
 * \file gtk.d - Wrapper for gtk.dll
 * Description: Wrapper for gtk.dll
 * Copyright (c) 2010 Danny Arends
 *
 * Contains: 
 * - private: static this
 *
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **/
 
module gtk.gtk;

private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import gtk.gtk_types;
import gtk.pango;
import gtk.gdk;

alias _GtkRcStyle GtkRcStyle;
struct _GtkRcStyle {
  GObject parent_instance;
  gchar *name;
  gchar *bg_pixmap_name[5];
  PangoFontDescription *font_desc;
  GtkRcFlags color_flags[5];
  GdkColor fg[5];
  GdkColor bg[5];
  GdkColor text[5];
  GdkColor base[5];
  gint xthickness;
  gint ythickness;
  GArray *rc_properties;
  GSList *rc_style_lists;
  GSList *icon_factories;
  guint engine_specified;
}

alias _GtkWidget GtkWidget;
struct _GtkWidget {
  GtkObject object;
  guint16 private_flags;
  guint8 state;
  guint8 saved_state;
  gchar* name;
  GtkStyle* style;
  GtkRequisition requisition;
  GtkAllocation allocation;
  GdkWindow* window;
  GtkWidget* parent;
}

alias _GtkWindow GtkWindow;
struct _GtkWindow {
  GtkBin bin;

  gchar *title;
  gchar *wmclass_name;
  gchar *wmclass_class;
  gchar *wm_role;

  GtkWidget *focus_widget;
  GtkWidget *default_widget;
  GtkWindow *transient_parent;
  GtkWindowGeometryInfo *geometry_info;
  GdkWindow *frame;
  GtkWindowGroup *group;

  guint16 configure_request_count;
  guint allow_shrink;
  guint allow_grow;
  guint configure_notify_received;
  guint need_default_position;
  guint need_default_size;
  guint position;
  guint type;
  guint has_user_ref_count;
  guint has_focus;
  guint modal;
  guint destroy_with_parent;
  guint has_frame;
  guint iconify_initially;
  guint stick_initially;
  guint maximize_initially;
  guint decorated;
  guint type_hint;
  guint gravity;
  guint is_active;
  guint has_toplevel_focus;
  guint frame_left;
  guint frame_top;
  guint frame_right;
  guint frame_bottom;
  guint keys_changed_handler;
  GdkModifierType mnemonic_modifier;
  GdkScreen *screen;
}

alias _GtkStyle GtkStyle;
align(1)  struct _GtkStyle {
  GObject parent_instance;
  
  GdkColor fg[5];
  GdkColor bg[5];
  GdkColor light[5];
  GdkColor dark[5];
  GdkColor mid[5];
  GdkColor text[5];
  GdkColor base[5];
  GdkColor text_aa[5];

  GdkColor black;
  GdkColor white;
  PangoFontDescription *font_desc;

  gint xthickness;
  gint ythickness;
  GdkGC *fg_gc[5];
  GdkGC *bg_gc[5];
  GdkGC *light_gc[5];
  GdkGC *dark_gc[5];
  GdkGC *mid_gc[5];
  GdkGC *text_gc[5];
  GdkGC *base_gc[5];
  GdkGC *text_aa_gc[5];
  GdkGC *black_gc;
  GdkGC *white_gc;

  GdkPixmap *bg_pixmap[5];
  gint attach_count;
  gint depth;
  GdkColormap *colormap;
  GdkFont *private_font;
  PangoFontDescription *private_font_desc;
  GtkRcStyle *rc_style;
  GSList *styles;
  GArray *property_cache;
  GSList *icon_factories;
}

alias _GtkBin GtkBin;
struct _GtkBin {
  GtkContainer container;
  GtkWidget *child;
}

alias _GtkContainer GtkContainer;
struct _GtkContainer {
  GtkWidget widget;
  GtkWidget *focus_child;
  guint border_width;
}

interface IWindow{
  HWindow handle(); // getter
}

struct CreateParams{
  GType type;
  GtkContainer* parent;
  char[] text;
}

alias GtkWidget* HWindow;
alias GdkRectangle GtkAllocation;

extern(C){
  //These are the functions we map to D from Rmath.h
  void function(int *argc, char*** argv) gtk_init;
  void function() gtk_main;
  void function() gtk_main_quit;
  
  GtkWidget* function(GtkWindowType type) gtk_window_new;
  void function(GtkWindow *window, gchar *title) gtk_window_set_title;
  gchar* function(GtkWindow *window) gtk_window_get_title;
  void function(GtkWindow *window, gint width, gint height) gtk_window_set_default_size;
  
  GType function() gtk_widget_get_type;
  GtkWidget* function(GType type, gchar *first_property_name, ...) gtk_widget_new;
  void function(GtkWidget *widget, gint width, gint height) gtk_widget_set_size_request;
  void function(GtkWidget *widget) gtk_widget_realize;
  void function(GtkWidget *widget) gtk_widget_show;
  GtkWidget* function() gtk_fixed_new;
  GType function() gtk_window_get_type;
    
  void function(GtkContainer *container, GtkWidget *widget) gtk_container_add;
  void function(GtkContainer *container, GtkWidget *widget) gtk_container_remove;
}

//Load the functions when the module is loaded
static this(){
  HXModule lib = load_library("libgtk-win32-2.0-0","gtk-x11-2.0");
  load_function(gtk_init)(lib,"gtk_init");
  load_function(gtk_main)(lib,"gtk_main");
  load_function(gtk_main_quit)(lib,"gtk_main_quit");
  
  load_function(gtk_window_new)(lib,"gtk_window_new");
  load_function(gtk_window_set_title)(lib,"gtk_window_set_title");
  load_function(gtk_window_get_title)(lib,"gtk_window_get_title");
  load_function(gtk_window_set_default_size)(lib,"gtk_window_set_default_size");
  
  load_function(gtk_widget_get_type)(lib,"gtk_widget_get_type");
  load_function(gtk_widget_new)(lib,"gtk_widget_new");
  load_function(gtk_widget_set_size_request)(lib,"gtk_widget_set_size_request");
  load_function(gtk_widget_realize)(lib,"gtk_widget_realize");
  load_function(gtk_widget_show)(lib,"gtk_widget_show");
  load_function(gtk_fixed_new)(lib,"gtk_fixed_new");
  load_function(gtk_window_get_type)(lib,"gtk_window_get_type");
  
  load_function(gtk_container_add)(lib,"gtk_container_add");
  load_function(gtk_container_remove)(lib,"gtk_container_remove");  
  
  gtk_init(null, null);
  writeln("Loaded GTK functionality");
}
