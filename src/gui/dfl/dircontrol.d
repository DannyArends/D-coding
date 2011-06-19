/**
 * \file dircontrol.d - Directory rendering
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
 * Contains: DirControl : An directory rendering widget for DFL (http://wiki.dprogramming.com/Dfl)
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 * 
 **/

module gui.dfl.dircontrol;

import dfl.all;
import std.file;
import dfl.treeview, dfl.event, dfl.base;

class DirControl: Panel{
  bool showAll = true;
  TreeView tree;
  ComboBox selection;
	CheckBox hiddenbox;
	Button newbtn;
	Button delbtn;
	Label hiddenlabel;
  
  this(){
    this("./");
  }

  this(string path){
    name="DirViewPanel";
    bounds = Rect(0, 0, 300, 600);
    tree = new TreeView();
    tree.name= "DirView";
    tree.bounds = Rect(0, 26, 296, 568);
    attachNodes(path,tree);
    tree.parent = this;
    
    selection = new ComboBox();
		selection.name = "Selection";
    selection.bounds = Rect(2, 2, 88, 21);
    selection.parent = this;
    
    hiddenbox = new dfl.button.CheckBox();
		hiddenbox.name = "hiddenbox";
		hiddenbox.bounds = Rect(164, 4, 16, 16);
		hiddenbox.parent = this;
    
    newbtn = new dfl.button.Button();
		newbtn.name = "newbtn";
		newbtn.text = "New";
		newbtn.bounds = Rect(185, 2, 50, 20);
		newbtn.parent = this;
    
    delbtn = new dfl.button.Button();
		delbtn.name = "delbtn";
		delbtn.text = "Del";
		delbtn.bounds = Rect(244, 2, 50, 20);
		delbtn.parent = this;
    
    hiddenlabel = new dfl.label.Label();
		hiddenlabel.name = "hiddenlabel";
		hiddenlabel.text = "Show Hidden";
		hiddenlabel.bounds = Rect(94, 5, 64, 16);
		hiddenlabel.parent = this;
  }
  
  void attachNodes(T)(string path, ref T node){
    foreach(string c;listdir(path)){
      if(showAll || c[0] != '.'){
        TreeNode currentNode = new TreeNode();
        currentNode.text = c;
        node.nodes.add(currentNode);
        if(isdir(path~"/"~c)){
          attachNodes(path~"/"~c,currentNode);
        }
      }
    }
  }
}
