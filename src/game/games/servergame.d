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

import core.stdinc;
import core.typedefs.types;
import core.arrays.algebra;
import core.events.engine;
import core.events.networkevent;
import game.engine;
import game.tilemap;
import gui.stdinc;
import sfx.engine;

class ServerGame : Game{
  public:
  void setup2D(Screen screen){
    writefln("[ G ] setup2D");
    time = new Text(screen, 0, screen.height-32);
    text = new Text(screen, 0, 0, screen.width, 64);
    text.setMaxLines(7);
    commandline = new TextInput(screen,0,screen.height-16,screen.width,16);
    screen.add(time);
    screen.add(text);
    screen.add(commandline);
  }

  void setup3D(Screen screen){
    writefln("[ G ] setup3D");
  }
  
  void setupSound(SFXEngine sound){
    writefln("[ G ] setupSound");    
  }

  void quit(){
    writefln("[ G ] quit");
    if(engine.network.isOnline()) engine.network.shutdown();
  }
  
  void load(){
    writefln("[ G ] load");
    engine.requestUpdate(1.0);
    engine.network.start();
    hudHandler(new HudHandler(engine.gfxengine));
  }
  
  void save(){
    writefln("[ G ] save");
  }
  
  void render(GFXEngine engine){
    time.setText(servertime.val);
  }
  
  void processGameCommand(string[] plist){
    switch(toLower(plist[0])){
      case "logout": engine.screen.reset3D(); break;
      default: break;
    }  
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
        case NetEvent.GAME:  writeln("[ G ] Network game event");
          if(n_evt.msg.length > 0){
            auto plist = split(n_evt.msg," ");
            writeln("[CLN] From server: ",plist[0]);
            if(plist.length > 1) writeln(", args:",plist[1..$]);
            processGameCommand(plist);
          }
          e.handled=true;
        break;
        case NetEvent.MOVEMENT:  writeln("[ G ] Movement event");
          e.handled=true;
        break;
        case NetEvent.CHAT:  writeln("[ G ] Chat event");
          text.addLine(n_evt.msg);
          e.handled=true;
        break;        
        case NetEvent.SOUND: writeln("[ G ] Sound event");
          e.handled=true;
        break;
        case NetEvent.GFX2D: writeln("[ G ] 2D object event");
          e.handled=true;
        break;
        case NetEvent.GFX3D: writeln("[ G ] 3D object event");
          cmap = new TileMap(n_evt.msg);
          HeightMap h = new HeightMap(0,0,0,cmap.x,cmap.y);
          engine.screen.add(h,"map");
          cameraMotion(new ObjectMotion(engine.screen,h));
          e.handled=true;
        break;
        default:
          writeln("[ G ] Unknown net event: ",n_evt.getNetEvent());
        break;
      }
    }
  }
  
  void update(){
    servertime.addSecond();
  }
  
  private:
    TileMap     cmap;
    TimeTracker servertime;
    Text        time;
    Text        text;
    TextInput   commandline;
}
