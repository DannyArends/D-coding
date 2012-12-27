/******************************************************************//**
 * \file src/plugins/optionsparser/optionsfile.d
 * \brief OptionsFile
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified May, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module plugins.optionsparser.optionsfile;

import std.stdio, std.math, std.array, std.conv, std.file, std.string;
import plugins.optionsparser.option;

class OptionsFile{
public:
  this(string filename){
    this.filename=filename;
    load();
  }
  
  bool load(){
    string linebuffer;
    if(filename.isFile){
      auto fin = new File(filename,"rb");
      while(fin.readln(linebuffer)){
        options ~= Option.parse(linebuffer);
      }
      fin.close();
      modified = false;
      return true;
    }
    return false;
  }
  
  bool save(){
    auto fout = new File(filename,"wb");
    foreach(Option o ; options){
      fout.write(o.toFileString());
    }
    fout.close();
    modified = false;
    return true;
  }
  
  Value getOptionValue(string name){
    if(getOption(name) !is null){
      return getOption(name).value;
    }else{
      return null;
    }
  }
  
  Option getOption(string name){
    uint i;
    if((i = contains(name)) >= 0){
      return options[i];
    }else{
      return null;
    }
  }
  
  bool addOption(Option toset){
    uint i;
    if((i = contains(toset.name)) >= 0){
      writeln("Update option: " ~ toset.name);
      options[i] = toset;      
    }else{
      writeln("Adding new option: " ~ toset.name);
      options ~= toset;
    }
    this.modified = true;
    return true;
  }
  
  int contains(string name){
    foreach(uint cnt,Option o ; options){
      if(o.name == name) return cnt;
    }
    return -1;
  }
  
private:
  string   filename;
  bool     modified;
  Option[] options;
}
