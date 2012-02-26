/**********************************************************************
 * \file src/game/games/servergame.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.games.servergame;

import std.stdio;

import core.typedefs.types;
import core.arrays.algebra;

import io.events.engine;
import game.engine;
import gui.stdinc;
import sfx.engine;

class ServerGame : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    text = new Text(10, 10, "", screen);
    screen.add(text);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(){
    writefln("[ G ] quit");
  }
  
  void load(GameEngine engine){
    writefln("[ G ] load");
    engine.requestUpdate(1.0);
  }
  
  void save(){
    writefln("[ G ] save");
  }
  
  void render(GFXEngine engine){
    text.setText(servertime.val);
  }
  
  void handle(Event e){
    if(e.getEventType() == EventType.NETWORK){
      writeln("[ G ] Network event");
      NetworkEvent n_evt = cast(NetworkEvent) e;
      if(n_evt.getNetEvent() == NetEvent.HEARTBEAT){
        writeln("[ G ] Network sync");
        servertime.fromString(n_evt.msg);
      }
    }
  }
  
  void update(){
    servertime.addSecond();
  }
  
  private:
    TimeTracker servertime;
    Text        text;
}
