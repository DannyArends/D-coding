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
 
module gtk.gdk;

private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import gtk.gtk_types;

alias _GdkColor GdkColor;
struct _GdkColor {
  guint32 pixel;
  guint16 red;
  guint16 green;
  guint16 blue;
}

enum GdkVisualType {
  GDK_VISUAL_STATIC_GRAY,
  GDK_VISUAL_GRAYSCALE,
  GDK_VISUAL_STATIC_COLOR,
  GDK_VISUAL_PSEUDO_COLOR,
  GDK_VISUAL_TRUE_COLOR,
  GDK_VISUAL_DIRECT_COLOR
};

enum GdkByteOrder {
  GDK_LSB_FIRST,
  GDK_MSB_FIRST
};

enum GdkFontType {
  GDK_FONT_FONT,
  GDK_FONT_FONTSET
};

alias _GdkFont GdkFont;
struct _GdkFont {
  GdkFontType type;
  gint ascent;
  gint descent;
}

alias _GdkDrawable GdkPixmap;

alias _GdkRectangle GdkRectangle;
struct _GdkRectangle {
  gint x;
  gint y;
  gint width;
  gint height;
}

alias _GdkVisual GdkVisual;
struct _GdkVisual {
  GObject parent_instance;
  GdkVisualType type;
  gint depth;
  GdkByteOrder byte_order;
  gint colormap_size;
  gint bits_per_rgb;

  guint32 red_mask;
  gint red_shift;
  gint red_prec;

  guint32 green_mask;
  gint green_shift;
  gint green_prec;

  guint32 blue_mask;
  gint blue_shift;
  gint blue_prec;
}


alias _GdkColormap GdkColormap;
struct _GdkColormap {
  GObject parent_instance;
  gint size;
  GdkColor *colors;
  GdkVisual *visual;
  gpointer windowing_data;
}

alias _GdkGC GdkGC;
struct _GdkGC {
  GObject parent_instance;
  gint clip_x_origin;
  gint clip_y_origin;
  gint ts_x_origin;
  gint ts_y_origin;
  GdkColormap *colormap;
}

enum GdkModifierType {
  GDK_SHIFT_MASK = 1 << 0,
  GDK_LOCK_MASK = 1 << 1,
  GDK_CONTROL_MASK = 1 << 2,
  GDK_MOD1_MASK = 1 << 3,
  GDK_MOD2_MASK = 1 << 4,
  GDK_MOD3_MASK = 1 << 5,
  GDK_MOD4_MASK = 1 << 6,
  GDK_MOD5_MASK = 1 << 7,
  GDK_BUTTON1_MASK = 1 << 8,
  GDK_BUTTON2_MASK = 1 << 9,
  GDK_BUTTON3_MASK = 1 << 10,
  GDK_BUTTON4_MASK = 1 << 11,
  GDK_BUTTON5_MASK = 1 << 12,
  GDK_RELEASE_MASK = 1 << 30,
  GDK_MODIFIER_MASK = GDK_RELEASE_MASK | 0x1fff
};

alias _GdkScreen GdkScreen;
struct _GdkScreen {
  GObject parent_instance;

  guint closed;

  GdkGC *normal_gcs[32];
  GdkGC *exposure_gcs[32];
}

alias _GdkDrawable GdkWindow;
struct _GdkDrawable {
  GObject parent_instance;
}

extern(C){

}

//Load the functions when the module is loaded
static this(){

}
