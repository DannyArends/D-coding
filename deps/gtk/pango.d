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
 
module gtk.pango;

private import std.loader;
private import std.stdio;
private import std.conv;

import core.libload.libload;
import gtk.gtk_types;

alias _PangoFontDescription PangoFontDescription;
alias void _PangoFontDescription;

alias _PangoAttrList PangoAttrList;
alias void _PangoAttrList;

alias _PangoLayout PangoLayout;
alias void _PangoLayout;

alias _PangoLayoutClass PangoLayoutClass;
alias void _PangoLayoutClass;
