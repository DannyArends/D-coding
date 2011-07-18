/**
 * \file fileloader.d
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends
 * 
 *     This program is free software; you can redistribute it and/or
 *     modify it under the terms of the GNU General Public License,
 *     version 3, as published by the Free Software Foundation.
 * 
 *     This program is distributed in the hope that it will be useful,
 *     but without any warranty; without even the implied warranty of
 *     merchantability or fitness for a particular purpose.  See the GNU
 *     General Public License, version 3, for more details.
 * 
 *     A copy of the GNU General Public License, version 3, is available
 *     at http://www.r-project.org/Licenses/GPL-3
 *
 * Contains: main
 * 
 **/

import std.stdio;
import std.conv;

import core.xbinary.io.xbinaryreader;
import core.xbinary.io.textreader;
 
void main(string[] args){
  TextReader reader = new TextReader();
  if(args.length > 2){
    switch(args[2]){
      case "2mb"  :reader.setBufferSize(BUFFERSIZE.BUFFER_2MB);break;
      case "4mb"  :reader.setBufferSize(BUFFERSIZE.BUFFER_4MB);break;
      case "16mb" :reader.setBufferSize(BUFFERSIZE.BUFFER_16MB);break;
      case "64mb" :reader.setBufferSize(BUFFERSIZE.BUFFER_64MB);break;
      case "256mb":reader.setBufferSize(BUFFERSIZE.BUFFER_256MB);break;
      default     :reader.setBufferSize(BUFFERSIZE.BUFFER_16KB);break;
    }
  }
  reader.split(args[1],args[2]);
}
