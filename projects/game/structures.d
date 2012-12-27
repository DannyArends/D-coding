/******************************************************************//**
 * \file src/game/structures.d
 * \brief Game structure definitions
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.structures;

import core.stdinc, core.terminal;
import core.typedefs.location;
import game.tilemap;

struct GameObj{
  uint           obj_uid;
  uint           creator_uid;
}

struct GameItem{
  uint           item_uid;
  uint           creator_uid;
  bool           wearable;
}

struct GameUser{
  string         name;
  string         pass;
  Location[2]    location;
  TileMap        map;
  string         created;
  string         lastloggedin;
  GameItem[12]   clothing;
  GameItem[25]   inventory;
  GameItem[500]  storage;
  GameObj[300]   assets;
}

GameUser EMPTYUSER   = GameUser();

/*! \brief Abstract game object class
 *
 *  Defines an abstract gameobject with its properties
 */
abstract class GameObject{
  public:
    this(string data){
      fromString(data);
    }

    this(string dir, string name){
      _filename = name;
      _filepath = dir ~ name;
      load();
    }
    
    void load(){
      if(exists(filepath) && isFile(filepath)){
        MSG("Loading GameObject-file: %s",filepath);
        fromString(readText(filepath));
        MSG("Done loading GameObject-file: %s",filepath);    
      }
    }

    void save(){
      MSG("Saving GameObject-file: %s",filepath);
      auto fp = new File(filepath,"wb");
      fp.write(asString());
      fp.close();
      MSG("Done saving GameObject-file: %s",filepath);  
    }
    
    @property{
      string     filepath(){ return _filepath; }
      string     filename(){ return _filename; }
    }

    abstract void fromString(string data);
    abstract string asString();

  private:
    string _filepath;
    string _filename;
}
