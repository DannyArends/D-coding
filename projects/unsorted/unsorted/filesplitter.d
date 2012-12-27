/**********************************************************************
 * \file src/main/filesplitter.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.conv;

import io.textreader;
 
void main(string[] args){
  TextReader reader = new TextReader();
  if(args.length > 3){
    reader.split(args[1],args[2],to!int(args[3]));
  }
}
