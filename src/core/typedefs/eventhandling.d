module core.typedefs.eventhandling;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import core.memory;

interface EventHandler{
  abstract void handleNetworkEvent(string s);
}