/******************************************************************//**
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

import game.engine;
import game.structures;
import game.tile;
import game.mover;

class TileMap : GameObject{
public:
  this(string data){ super(data); }

  this(string dir, string name, uint x = 10, uint y = 10){
    super(dir, name);
    if(!exists(filepath) || !isFile(filepath)){
      tiles = newmatrix!TileType(x, y, GRASSTILE);
      save();  // Creating a new map
    }
  }

  double getMovementCost(Mover mover, uint x, uint y, uint xp, uint yp){
    return 1.0;
  }

  bool isValidLocation(Mover mover, uint x,uint y, uint xp, uint yp){
    if(xp < this.x && xp >= 0 && yp < this.y && yp >= 0) return true;
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
  
  @property{
    string     name(){ return filename; }
    uint       x(){ return tiles.length; }
    uint       y(){ return tiles[0].length; }
    float[][]  heightmap(){
      float[][] heights;
      for(size_t x = 0; x < tiles.length; x++){
        float[] r_heights;
        for(size_t y = 0; y < tiles[x].length; y++){
          r_heights ~= tiles[x][y].cost;
        }
        heights ~= r_heights;
      }
      return heights;
    }
    FileStatus status(){ return _status; }
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
  
  override void fromString(string data){
    string[] lines = splitLines(data);
    writeln("[MAP] Start of parsing ",lines.length," lines of data");
    int currentline = 0;
    while(currentline < lines.length){
      if(chomp(lines[currentline]) == "# --- Data tiledefs begin"){
        writeln("[MAP] Tile definitions");
        currentline++;
        while(currentline < lines.length){
          if(chomp(lines[currentline]) == "# --- Data tiledefs end"){
            writeln("[MAP] Tile definitions done");
            break;
          }
          if(lines[currentline][0] == '#') continue;
          parseTileDefs(chomp(lines[currentline]));
          currentline++;
        }
      }
      
      if(chomp(lines[currentline]) == "# --- Data tiles begin"){
        writeln("[MAP] Tiles");
        currentline++;
        while(currentline < lines.length){
          if(chomp(lines[currentline]) == "# --- Data tiles end"){
            _status = FileStatus.OK;
            writeln("[MAP] Tiles done");
            break;
          }
          if(lines[currentline][0] == '#') continue;
          parseTiles(chomp(lines[currentline]));
          currentline++;
        }
      }
      currentline++;
    }
  }
  
  override string asString(){
    string s;
    s ~= "# --- Data tiledefs begin\n";
    foreach(TileType t; uniqueTiles()){
      s ~= t.toDescription ~ "\n";
    }
    s ~= "# --- Data tiledefs end\n";
    s ~= "# --- Data tiles begin\n";
    for(size_t x = 0; x < tiles.length; x++){
      for(size_t y = 0; y < tiles[x].length; y++){
        if(y!=0) s ~= "\t";
        s ~= to!string(tiles[x][y]);
      }
      s ~= "\n";
    }
    s ~= "# --- Data tiles end\n";
    return s;
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

  private:
    TileType[][] tiles;
    TileType[]   tiledefs;
    FileStatus   _status = FileStatus.NO_SUCH_FILE;
}
