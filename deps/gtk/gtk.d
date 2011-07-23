/**
 * \file gtk.d - Wrapper for gtk.dll
 * Description: Wrapper for gtk.dll
 * Based on DFL gtk version, Copyright (c) 2011 Danny Arends
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

alias _GtkLabel GtkLabel;
struct _GtkLabel {
  GtkMisc misc;
  gchar *label;
  guint jtype;
  guint wrap;
  guint use_underline;
  guint use_markup;
  guint mnemonic_keyval;
  gchar *text;
  PangoAttrList *attrs;
  PangoAttrList *effective_attrs;
  PangoLayout *layout;
  GtkWidget *mnemonic_widget;
  GtkWindow *mnemonic_window;
  GtkLabelSelectionInfo *select_info;
}

alias _GtkBox GtkBox;
struct _GtkBox{
  GtkContainer container;
  GList *children;
  gint16 spacing;
  guint homogeneous;
}

alias _GtkButton GtkButton;
struct _GtkButton{
  GtkBin bin;
  GdkWindow *event_window;
  gchar *label_text;
  guint activate_timeout;
  guint in_button;
  guint button_down;
  guint relief;
  guint use_underline;
  guint use_stock;
  guint depressed;
  guint depress_on_activate;
  guint focus_on_click;
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

alias _GtkMisc GtkMisc;
struct _GtkMisc {
  GtkWidget widget;
  gfloat xalign;
  gfloat yalign;
  guint16 xpad;
  guint16 ypad;
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
  bool function(int *argc, char*** argv) gtk_init_check;
  void function() gtk_main;
  void function() gtk_main_quit;
  
  GtkWidget* function(GtkWindowType type) gtk_window_new;
  void function(GtkWindow *window, gchar *title) gtk_window_set_title;
  gchar* function(GtkWindow *window) gtk_window_get_title;
  void function(GtkWindow *window, gint width, gint height) gtk_window_set_default_size;
  
  
  GtkWidget* function(GType type, gchar *first_property_name, ...) gtk_widget_new;
  void function(GtkWidget *widget, gint width, gint height) gtk_widget_set_size_request;
  void function(GtkWidget *widget) gtk_widget_realize;
  void function(GtkWidget *widget) gtk_widget_show;
  GtkWidget* function() gtk_fixed_new;
  
  GType function() gtk_widget_get_type;
  GType function() gtk_window_get_type;
  GType function() gtk_label_get_type;
  GType function() gtk_hbox_get_type;
  GType function() gtk_button_get_type;

  GtkWidget* function() gtk_button_new;
  GtkWidget* function(gchar *label) gtk_button_new_with_label;

  void function(GtkLabel *label, char *str) gtk_label_set_text;
  void function(GtkButton *button, char *label) gtk_button_set_label;
  char* function(GtkLabel *label) gtk_label_get_text;

  void function(GtkBox *box, GtkWidget *child, gboolean expand, gboolean fill, guint padding) gtk_box_pack_start;
  void function(GtkBox *box, GtkWidget *child, gboolean expand, gboolean fill, guint padding) gtk_box_pack_end;

  void function(GtkMisc *misc, gfloat xalign, gfloat yalign) gtk_misc_set_alignment;
    
  void function(GtkContainer *container, GtkWidget *widget) gtk_container_add;
  void function(GtkContainer *container, GtkWidget *widget) gtk_container_remove;
}

//Load the functions when the module is loaded
static this(){
  HXModule lib = load_library("libgtk-win32-2.0-0","gtkgl-2.0");
  load_function(gtk_init)(lib,"gtk_init");
  load_function(gtk_init_check)(lib,"gtk_init_check");
  load_function(gtk_main)(lib,"gtk_main");
  load_function(gtk_main_quit)(lib,"gtk_main_quit");
  
  load_function(gtk_window_new)(lib,"gtk_window_new");
  load_function(gtk_window_set_title)(lib,"gtk_window_set_title");
  load_function(gtk_window_get_title)(lib,"gtk_window_get_title");
  load_function(gtk_window_set_default_size)(lib,"gtk_window_set_default_size");
  
  load_function(gtk_widget_new)(lib,"gtk_widget_new");
  load_function(gtk_widget_set_size_request)(lib,"gtk_widget_set_size_request");
  load_function(gtk_widget_realize)(lib,"gtk_widget_realize");
  load_function(gtk_widget_show)(lib,"gtk_widget_show");
  load_function(gtk_fixed_new)(lib,"gtk_fixed_new");

  load_function(gtk_widget_get_type)(lib,"gtk_widget_get_type");
  load_function(gtk_window_get_type)(lib,"gtk_window_get_type");
  load_function(gtk_label_get_type)(lib,"gtk_label_get_type");
  load_function(gtk_hbox_get_type)(lib,"gtk_hbox_get_type");
  load_function(gtk_button_get_type)(lib,"gtk_button_get_type");

  load_function(gtk_button_new)(lib,"gtk_button_new");
  load_function(gtk_button_new_with_label)(lib,"gtk_button_new_with_label");

  load_function(gtk_label_set_text)(lib,"gtk_label_set_text");
  load_function(gtk_button_set_label)(lib,"gtk_button_set_label");
  load_function(gtk_label_get_text)(lib,"gtk_label_get_text");

  load_function(gtk_box_pack_start)(lib,"gtk_box_pack_start");
  load_function(gtk_box_pack_end)(lib,"gtk_box_pack_end");

  load_function(gtk_misc_set_alignment)(lib,"gtk_misc_set_alignment");

  load_function(gtk_container_add)(lib,"gtk_container_add");
  load_function(gtk_container_remove)(lib,"gtk_container_remove");  
  
  if(gtk_init_check(null, null)){
    writeln("Loaded GTK functionality");
  }else{
    writeln("Couldn't load GTK functionality");
  }
}
