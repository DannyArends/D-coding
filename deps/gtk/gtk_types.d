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
 
module gtk.gtk_types;

private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;

alias uint size_t;
alias int wchar_t;

alias byte gint8;
alias ubyte guint8;
alias short gint16;
alias ushort guint16;

alias int gint32;
alias uint guint32;

alias long gint64;
alias ulong guint64;

alias char gchar;
alias short gshort;
alias int glong;
alias int gint;
alias gint gboolean;

alias ubyte guchar;
alias ushort gushort;
alias uint gulong;
alias uint guint;

alias float gfloat;
alias double gdouble;
alias gulong GType;

alias _GData GData;
alias void _GData;
alias void* gpointer;

enum ControlStyles: uint {
  NONE =                             0,
  CONTAINER_CONTROL =                0x1,
  USER_PAINT =                       0x2,
  OPAQUE =                           0x4,
  RESIZE_REDRAW =                    0x10,
  FIXED_WIDTH =                      0x20,
  FIXED_HEIGHT =                     0x40,
  STANDARD_CLICK =                   0x100,
  SELECTABLE =                       0x200,
  USER_MOUSE =                       0x400,


  STANDARD_DOUBLE_CLICK =            0x1000,
  ALL_PAINTING_IN_WM_PAINT =         0x2000,
  CACHE_TEXT =                       0x4000,
  DOUBLE_BUFFER =                    0x10000,
  WANT_TAB_KEY =                     0x01000000,
}

alias _GTypeClass GTypeClass;
struct _GTypeClass {
  GType g_type;
}

alias _GTypeInstance GTypeInstance;
struct _GTypeInstance {
  GTypeClass *g_class;
}

alias _GObject GObject;
struct _GObject {
  GTypeInstance g_type_instance;
  guint ref_count;
  GData *qdata;
}

alias _GtkWindowGeometryInfo GtkWindowGeometryInfo;
alias void _GtkWindowGeometryInfo;

alias _GtkLabelSelectionInfo GtkLabelSelectionInfo;
alias void _GtkLabelSelectionInfo;

alias _GtkWindowGroup GtkWindowGroup;
struct _GtkWindowGroup {
  GObject parent_instance;
  GSList *grabs;
}

enum GtkRcFlags {
  GTK_RC_FG = 1 << 0,
  GTK_RC_BG = 1 << 1,
  GTK_RC_TEXT = 1 << 2,
  GTK_RC_BASE = 1 << 3
};

enum GtkWindowType {
  GTK_WINDOW_TOPLEVEL,
  GTK_WINDOW_POPUP
};

alias _GArray GArray;
struct _GArray {
  gchar *data;
  guint len;
}

alias _GSList GSList;
struct _GSList {
  gpointer data;
  GSList *next;
}

alias _GtkObject GtkObject;
struct _GtkObject {
  GObject parent_instance;
  guint32 flags;
}

alias _GtkRequisition GtkRequisition;
struct _GtkRequisition {
  gint width;
  gint height;
}

struct Size{
  int width;
  int height;

  static Size opCall(int width, int height){
    Size sz;
    sz.width = width;
    sz.height = height;
    return sz;
  }

  static Size opCall(){
    Size sz;
    return sz;
  }

  const bool opEquals(ref const Size sz){ return width == sz.width && height == sz.height;}

  Size opAdd(Size sz){
    Size result;
    result.width = width + sz.width;
    result.height = height + sz.height;
    return result;
  }

  Size opSub(Size sz){
    Size result;
    result.width = width - sz.width;
    result.height = height - sz.height;
    return result;
  }

  void opAddAssign(Size sz){
    width += sz.width;
    height += sz.height;
  }

  void opSubAssign(Size sz){
    width -= sz.width;
    height -= sz.height;
  }
}
