/**********************************************************************
 * \file src/main/single_map_probes.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.conv;

import io.singlemap;
 
void main(string[] args){
  SingleMap reader = new SingleMap();
  if(args.length > 3){
    reader.readInNames(args[1]);
    reader.writeOutput(args[2],args[3]);
  }
}
