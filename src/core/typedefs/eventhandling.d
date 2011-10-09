module core.typedefs.eventhandling;

import std.stdio;
import std.conv;
import std.math;

interface EventHandler{
  abstract void handleNetworkEvent(string s);
}