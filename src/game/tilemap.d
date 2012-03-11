/**********************************************************************
 * \file src/game/tilemap.d
 * \brief A game map in tiles
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/

module game.tilemap;

import core.stdinc;
import std.algorithm;
import core.arrays.types;
import core.arrays.search;
import core.typedefs.types;

import game.tile;
import game.mover;

class TileMap{
public:  
  this(string dir, string name, uint x = 10, uint y = 10){
    mapname = name;
    filename = dir ~ name;
    if(!exists(filename) || !isFile(filename)){
      tiles = newmatrix!TileType(x, y, BLOCKEDTILE);
      save();  // Creating a new map
    }else{
      load();  // Load the map from file
    }
  }

  double getMovementCost(Mover mover, uint x, uint y, uint xp, uint yp){
    return 1.0;
  }

  bool isValidLocation(Mover mover, uint x,uint y, uint xp, uint yp){
    return false;
  }

  TileType getTileType(uint x, uint y){
    return tiles[x][y]; 
  }

  void pathFinderVisited(uint x, uint y){
  
  }

  bool isBlocked(Mover mover, uint x, uint y){
    return true;
  }
  
  @property uint x(){ return tiles.length; }
  @property uint y(){ return tiles[0].length; }
  @property FileStatus status(){ return _status; }

  void load(){
    writefln("Opening map-file: %s",filename);
    auto fp = new File(filename,"rb");
    string buffer;
    int cnt=0;
    while(fp.readln(buffer)){
      if(chomp(buffer) == "# --- Data tiledef begin"){
        writeln("[MAP] Tile definitions");
        while(fp.readln(buffer)){
          if(chomp(buffer) == "# --- Data tiledef end"){
            writeln("[MAP] Tile definitions done");
            break;
          }
          if(buffer[0] == '#') continue;
          parseTileDefs(chomp(buffer));
        }
      }
      
      if(chomp(buffer) == "# --- Data tiles begin"){
        writeln("[MAP] Tiles ");
        while(fp.readln(buffer)){
          if(chomp(buffer) == "# --- Data tiles end"){
            _status = FileStatus.OK;
            writeln("[MAP] Tiles done");
            break;
          }
          if(buffer[0] == '#') continue;
          parseTiles(chomp(buffer));
        }
      }
    }
    fp.close();
    writefln("Done map-file: %s",filename);
  }

  void parseTileDefs(string buffer){
    auto fields = split(buffer,"\t");
    if(fields.length == 2){
      tiledefs ~= TileType(to!double(fields[1]),to!char(fields[0]));
    }
  }

  void parseTiles(string buffer){
    auto fields = split(buffer,"\t");
    if(fields.length > 0){
      TileType[] rowoftiles;
      foreach(string field; fields){
        if(field != "") rowoftiles ~= TileType(to!char(field),tiledefs);
      }
      tiles ~= rowoftiles;
    }
  }

  void save(){
    writefln("Opening map-file: %s",filename);
    auto fp = new File(filename,"wb");
    fp.writeln("# --- Data tiledefs begin");
    foreach(TileType t; uniqueTiles()){
      fp.writeln(t.toDescription);
    }
    fp.writeln("# --- Data tiledefs end");
    fp.writeln("# --- Data tiles begin");
    for(size_t x = 0; x < tiles.length; x++){
      for(size_t y = 0; y < tiles[x].length; y++){
        if(y!=0)fp.write("\t");
        fp.write(tiles[x][y]);
      }
      fp.write("\n");
    }
    fp.writeln("# --- Data tiles end");
    fp.close();
    writefln("Done map-file: %s",filename);    
  }

  TileType[] uniqueTiles(){
    TileType[] uniques;
    for(size_t x = 0; x < tiles.length; x++){
      for(size_t y = 0; y < tiles[x].length; y++){
        if(!searcharray(uniques,tiles[x][y])) uniques ~= tiles[x][y];
      }
    }
    return uniques;
  }

  @property string name(){ return mapname; }
  
  private:
    string       mapname;
    string       filename;
    TileType[][] tiles;
    TileType[]   tiledefs;
    FileStatus   _status = FileStatus.NO_SUCH_FILE;
}
