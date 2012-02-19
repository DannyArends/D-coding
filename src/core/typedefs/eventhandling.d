/**********************************************************************
 * \file src/core/typedefs/eventhandling.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.typedefs.eventhandling;

import std.stdio;
import std.conv;
import std.math;

interface EventHandler{
  abstract void handleNetworkEvent(string s);
}