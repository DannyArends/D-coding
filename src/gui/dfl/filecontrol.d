/**
 * \file file.d - File rendering
 *
 * last modified May, 2011
 * first written May, 2011
 *
 * Copyright (c) 2010 Danny Arends, Joeri v/d Velde, Pjotr Prins, Karl W. Broman, Ritsert C. Jansen
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
 * Contains: FileControl : An file rendering widget for DFL (http://wiki.dprogramming.com/Dfl)
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 * 
 **/

module gui.dfl.filecontrol;

import dfl.all;
import std.file;
import std.conv;
import std.stdio;
import std.string;
import dfl.event, dfl.base;
import core.io.iofunctions;
import core.io.textreader;

string[] txt_ext = [".txt", ".csv",".d", ".di",".md"];
string[] img_ext = [".tga",".jpg",".gif"];


class FileControl: Panel{
	Label namelabel;
  TextBox fileContent;
  Button savebtn;
    
  this(){
    this("./");
  }
  
  bool isKnown(string filename,string[] exts){
    if(!exists(filename) || !isfile(filename)) return false;
    foreach(string ext; exts){
  		if (filename.length>=ext.length && filename[($-ext.length)..$]==ext){
  			return true;
      }
    }
    return false;
  }
  
  void OnSelect_click(TreeView t, TreeViewEventArgs e) {
    if(!isKnown(e.node.fullPath,txt_ext)) return;
    namelabel.text = "Path: " ~ e.node.fullPath;
    fileContent.text = "";
    ubyte[] inputbuffer = new ubyte[1];
    auto f = new File(e.node.fullPath,"rb");
    string line;
    while(f.rawRead(inputbuffer)){
      foreach(byte b ; inputbuffer){
        line ~= cast(char)(b);
      }
    }
    fileContent.appendText(line);
  }
  
  this(string path){
    name="FileViewPanel";
    bounds = Rect(0, 0, 900, 900);
    
    namelabel = new dfl.label.Label();
		namelabel.name = "namelabel";
		namelabel.text = "";
		namelabel.bounds = Rect(2, 5, 300, 16);
		namelabel.parent = this;
    
    fileContent = new dfl.textbox.TextBox();
    fileContent.multiline = true;
    fileContent.wordWrap = false;
    fileContent.maxLength = uint.max;
		fileContent.name = "fileContent";
		fileContent.text = "";
		fileContent.bounds = Rect(2, 26, 900, 868);
		fileContent.parent = this;
    
    savebtn = new dfl.button.Button();
		savebtn.name = "savebtn";
		savebtn.text = "Save";
		savebtn.bounds = Rect(402, 2, 50, 20);
		savebtn.parent = this;
  }
}
