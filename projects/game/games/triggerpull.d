/******************************************************************//**
 * \file src/game/games/triggerpull.d
 * \brief Triggerpull game definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written May, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.games.triggerpull;

import std.stdio, std.string, std.conv, std.file, core.terminal;
import core.typedefs.types, core.arrays.algebra, core.events.engine;
import core.events.mouseevent, game.engine, game.games.empty, gui.stdinc;
import sfx.engine, sfx.formats.wav;

class TriggerPull : Empty{

  override void setup2D(Screen screen){ super.setup2D(screen);
    text = new Text(screen, 10, 10);
    screen.add(text);
  }

  override void setup3D(Screen screen){ super.setup3D(screen);
    gun = new Quad(1.4,-0.4,0);
    gun.direction = [0.0,0.0,0.0];
    gun.setTexture(screen.getTextureID("Gun"));
    gun.setSize(3.5, 1.5, 1.0);
    screen.add(gun);
  }
  
  override void setupSound(SFXEngine sound){ gunsound = sound.getSound("gun"); }
  
  override void load(){
    engine.requestUpdate(1.0);
    if(!exists(filename)){
      WARN("No save game found: '%s'",filename);
    }else{
      auto fp = new File(filename,"rb");
      string buffer;
      int cnt=0;
      fp.readln(buffer);
      buffer = chomp(buffer);
      string[] entities = buffer.split("\t");
      foreach(string e; entities){cnts ~= to!int(e); }
      fp.close();
      wGAME("Saved game '%s' loaded", filename);
    }
    wGAME("Welcome to 'Triggerpull reloaded'");
  }
  
  override void save(){
    auto fp = new File(filename,"wb");
    string buffer = "";
    int cnt = 0;
    foreach(int c; cnts){
      if(cnt >= 1) buffer ~= "\t";
      buffer ~= to!string(c); 
      cnt++;
    }
    fp.writeln(buffer);
    fp.close();
    wGAME("Saved game '%s'", filename);
  }
  
  override void render(GFXEngine engine){
    text.setText("Playing: " ~ to!string(cnts.length) ~ " seconds");
    text.addLine("Rate Of Fire: " ~ to!string(click_cnt));
    text.addLine("Max ROF/sec: " ~ to!string(max!int(cnts)));
    int total_clicks = sum!int(cnts);
    float avg = (cast(int)(100*(total_clicks/(cnts.length+0.1)))) / 100.0;
    foreach(int z; [10,60,600]){
      if(cnts.length > z){
        text.addLine("ROF last " ~ to!string(z) ~ " seconds: " ~ to!string(sum!int(cnts[$-z..$])) ~ " Best: " ~ to!string(maxOf!int(cnts,z)));
      }
    }
    text.addLine("Total / Avg ROF: " ~ to!string(total_clicks) ~ " / " ~ to!string(avg));
  }
  
  override void handle(Event e){
    if(e.getEventType() == EventType.MOUSE){
      MouseEvent m_evt = cast(MouseEvent) e;
      switch(m_evt.getBtn()){
        case MouseBtn.LEFT:
          if(m_evt.getType==KeyEventType.DOWN){
          gunsound.play();
          click_cnt++;
          }
        break;
        default:break;
      }
    }
  }
  
  override void update(){
    cnts ~= click_cnt;
    click_cnt = 0;
  }
  
private:
  string filename = "TP.save";
  Text   text;
  Quad   gun;
  Sound  gunsound;
  int    click_cnt = 0;
  int[]  cnts;
}
