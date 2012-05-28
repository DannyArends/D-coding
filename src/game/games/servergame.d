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

import core.stdinc, core.typedefs.types, core.typedefs.location;
import core.events.engine, core.terminal, core.events.networkevent;
import game.engine,game.games.empty, game.player, game.tilemap;
import gui.stdinc, sfx.engine;

class ServerGame : Empty{
  public:
  override void setup2D(Screen screen){ super.setup2D(screen);
    time = new Text(screen, 0, screen.height-32);
    text = new Text(screen, 0, 0, screen.width, 64);
    text.setMaxLines(7);
    commandline = new TextInput(screen,0,screen.height-16,screen.width,16);
    screen.add(time);
    screen.add(text);
    screen.add(commandline);
  }

  override void quit(){ super.quit();
    if(engine.network.isOnline()) engine.network.shutdown();
  }
  
  override void load(){ super.load();
    engine.requestUpdate(1.0);
    engine.network.start();
    hudHandler(new HudHandler(engine.gfxengine));
  }
    
  override void render(GFXEngine engine){
    time.setText(servertime.val);
  }
  
  void processGameCommand(string[] plist){
    switch(toLower(plist[0])){
      case "logout": engine.screen.reset3D(); break;
      default: break;
    }  
  }

  void createObject(string objectData){
    int idx = objectData.indexOf(':');
    if(idx > 0){
      string objectType = objectData.split(":")[0];
      objectData = objectData[idx+1..$];
      switch(objectType){
        case "Map":    wGAME("New Map data received"); 
          TileMap map = new TileMap(objectData);
          HeightMap hmap = new HeightMap(0, 0, 0, map.heightmap, map.colormap);
          engine.screen.add(hmap,"map");
        break;
        case "User":   wGAME("User data received");
          Player p = new Player(objectData);
          Location l = p.info.location[0];
          Skeleton sk = new Skeleton(l.x, l.y, l.z);
          cameraMotion(new ObjectMotion(engine.screen,sk));
          engine.screen.add(sk,"player");
        break;
        case "Player": wGAME("New Player"); break;
        case "NPC":    wGAME("New NPC"); break;
        case "Struct": wGAME("New Structure"); break;
        default: WARN("Received unknown object type (%s)",objectType);
        break;
      }
    }
  }

  
  override void handle(Event e){
    if(e.getEventType() == EventType.NETWORK){
      NetworkEvent n_evt = cast(NetworkEvent) e;
      switch(n_evt.getNetEvent()){
        case NetEvent.HEARTBEAT:
          wGAME("Received: Network sync");
          servertime.fromString(n_evt.msg);
          e.handled=true;
        break;
        case NetEvent.GAME:  wGAME("Received: Network game event");
          if(n_evt.msg.length > 0){
            auto plist = split(n_evt.msg," ");
            writeln("[CLN] From server: ",plist[0]);
            if(plist.length > 1) writeln(", args:",plist[1..$]);
            processGameCommand(plist);
          }
          e.handled=true;
        break;
        case NetEvent.MOVEMENT:  wGAME("Received: Movement event");
          e.handled=true;
        break;
        case NetEvent.CHAT:      wGAME("Received: Chat event");
          text.addLine(n_evt.msg);
          e.handled=true;
        break;        
        case NetEvent.SOUND:     wGAME("Received: Sound event");
          e.handled=true;
        break;
        case NetEvent.OBJECT:    wGAME("Received: Object event");
          createObject(n_evt.msg);
          e.handled=true;
        break;
        case NetEvent.GFX2D:     wGAME("Received: GFX2D event");
          e.handled=true;
        break;
        case NetEvent.GFX3D:     wGAME("Received: GFX3D event");
          e.handled=true;
        break;
        default:
          WARN("Received: Unknown Network event: '%s'",n_evt.getNetEvent());
        break;
      }
    }
  }
  
  override void update(){
    servertime.addSecond();
  }
  
  private:
    TimeTracker servertime;
    Text        time;
    Text        text;
    TextInput   commandline;
}
