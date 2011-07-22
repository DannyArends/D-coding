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
 
module gtk.pango;

private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import gtk.gtk_types;

alias _PangoFontDescription PangoFontDescription;
alias void _PangoFontDescription;