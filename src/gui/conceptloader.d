module gui.conceptloader;

import std.stdio;
import std.conv;
import std.math;
import std.string;
import std.array;
import std.file;
import std.regex;
import core.typedefs.eventhandling;

import gui.enginefunctions;
import gui.formats.tga;

enum LoaderType {TEXTURE, MAP, OBJECT3DS, HUDWINDOW };

abstract class EngineLoader{
  LoaderType type;
  abstract void load();
}

class Object3DSLoader : EngineLoader{
  this(){
    type = LoaderType.OBJECT3DS;
  }
}

class MapLoader : EngineLoader{
  this(){
    type = LoaderType.OBJECT3DS;
  }
}

class HudWindowLoader : EngineLoader{
  this(){
    type = LoaderType.HUDWINDOW;
  }
}
// Concept plain csv file loader (heightmap, soil/typemap, objectmap)
//CsvInfo!double csvData = loadCsvFile!double("data/fun/csv_header.txt",true);
//writeln(csvData);
//writeCsvFile("t.txt",csvData);
//Perhaps:
// TgaInfo.load(filename) / CsvInfo.load(filename)
// TgaInfo.save(filename) / CsvInfo.save(filename)