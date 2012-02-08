module gui.formats.csv;

import std.stdio;
import std.array;
import std.string;
import std.conv;
import std.file;
import std.regex;

import core.typedefs.types;
import gui.objects.color;

import gl.gl_1_0;
import gl.gl_1_1;

enum CsvType{ 
  CSV_ERROR_NO_SUCH_FILE = -6, 
  CSV_OK_HEADER = 0,
  CSV_OK_NO_HEADER = 1
}

struct CsvInfo(T){
  string     name;
  string     sep;
  CsvType    status;
  string[]   colnames;
  string[]   rownames;
  T[][] data;
  
  string toString(){
    string s;
    if(status == CsvType.CSV_OK_HEADER){
      for(auto c=0;c < colnames.length;c++){
        s ~= sep ~ colnames[c];
      }
      s ~= "\n";
    }
    for(auto i=0;i < rownames.length;i++){
      if(status == CsvType.CSV_OK_HEADER) s ~= rownames[i];
      for(auto c=0;c < colnames.length;c++){
        if(c==0 && status == CsvType.CSV_OK_NO_HEADER){
          s ~= to!string(data[i][c]);
        }else{
          s ~= sep ~ to!string(data[i][c]);
        }
      }
      s ~= "\n";
    }
    return s;
  }
}

T[] stringArrayToType(T)(string[] entities){
  T[] rowleveldata;
  for(auto e=0;e < entities.length; e++){
    rowleveldata ~= to!T(entities[e]);
  }
  return rowleveldata;
}

bool writeCsvFile(T)(string filename, CsvInfo!T toSave){
    auto fp = new File(filename,"wb");
    fp.write(toSave);
    fp.close();
    return true;
}

CsvInfo!T loadCsvFile(T)(string filename, bool header = false){
  return loadCsvFile!T(filename, "\t", header);
}

CsvInfo!T loadCsvFile(T)(string filename, string sep="\t", bool header = false){
  CsvInfo!T csvData = CsvInfo!T(filename);
  if(!exists(filename) || !isfile(filename)){
    writefln("No such file: %s",filename);
    csvData.status = CsvType.CSV_ERROR_NO_SUCH_FILE;
    return csvData;
  }
  writefln("Opening csv-file: %s",filename);
  auto fp = new File(filename,"rb");
  string buffer;
  int cnt=0;
  while(fp.readln(buffer)){
    buffer = chomp(buffer);
    string[] entities = buffer.split(sep);
    if(header){
      if(entities.length <= 1){
        writeln("Unable to parse line: " ~ to!string(cnt));
      }else{
        if(cnt==0){
          csvData.colnames = entities[1..$];
        }else{
          csvData.rownames ~= entities[0];
          csvData.data ~= stringArrayToType!T(entities[1..$]);
        }
      }
    }else{
      csvData.data ~= stringArrayToType!T(entities);
    }
    cnt++;
  }
  csvData.sep = sep;
  if(header){
    csvData.status = CsvType.CSV_OK_HEADER;
  }else{
    csvData.status = CsvType.CSV_OK_NO_HEADER;
  }
  writeln("Read: " ~ to!string(cnt) ~ " lines");
  return csvData;
}