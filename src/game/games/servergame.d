/******************************************************************//**
 * \file src/game/games/servergame.d
 * \brief ServerGame class definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written May, 2011<br>
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
    commandline = new TextInput(screen,30,30);
    screen.add(text);
    screen.add(commandline);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(GameEngine engine){
    writefln("[ G ] quit");
    if(engine.network.isOnline()) engine.network.shutdown();
  }
  
  void load(GameEngine engine){
    writefln("[ G ] load");
    engine.requestUpdate(1.0);
    engine.network.start();
    hudHandler(new HudHandler(engine.gfxengine));
  }
  
  void save(){
    writefln("[ G ] save");
  }
  
  void render(GFXEngine engine){
    text.setText(servertime.val);
  }
  
  void handle(Event e){
    if(e.getEventType() == EventType.NETWORK){
      NetworkEvent n_evt = cast(NetworkEvent) e;
      switch(n_evt.getNetEvent()){
        case NetEvent.HEARTBEAT:
          writeln("[ G ] Network sync");
          servertime.fromString(n_evt.msg);
          e.handled=true;
        break;
        case NetEvent.GAME:
          writeln("[ G ] Network game event");
          e.handled=true;
        break;
        default:
        break;
      }
    }
  }
  
  void update(){
    servertime.addSecond();
  }
  
  private:
    TimeTracker servertime;
    Text        text;
    TextInput   commandline;
}
