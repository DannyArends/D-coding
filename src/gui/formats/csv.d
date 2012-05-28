/******************************************************************//**
 * \file src/gui/formats/csv.d
 * \brief CSV file format definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module gui.formats.csv;

import core.stdinc, core.terminal, core.typedefs.types;
import core.typedefs.files, core.typedefs.color;

import gl.gl_1_0;
import gl.gl_1_1;

enum CsvType{ CSV_ERROR = -6, CSV_OK_HEADER = 0, CSV_OK_NO_HEADER = 1 }

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
  if(checkFile(filename) != FileStatus.IS_FILE){
    csvData.status = CsvType.CSV_ERROR;
    return csvData;
  }
  MSG("Opening .csv file: '%s'",filename);
  auto lines = splitLines(readText(filename));
  
  int cnt=0;
  foreach(line; lines){
    string[] entities = chomp(line).split(sep);
    if(header){
      if(entities.length <= 1){
        WARN("Unable to parse line: " ~ to!string(cnt));
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
  MSG("Parsed: %s lines",cnt);
  return csvData;
}
