module game.games.triggerpull;

import std.stdio;
import std.string;
import std.conv;
import std.file;

import core.arrays.algebra;

import io.events.engine;
import io.events.mouseevent;
import game.engine;
import gui.stdinc;
import sfx.engine;
import sfx.formats.wav;


class TriggerPull : Game{

  void setup2D(Screen screen){
    text = new Text(10,10,"",screen);
    screen.add(text);
  }

  void setup3D(Screen screen){
    gun = new Quad(1.4,-0.4,0);
    gun.setRotation(0.0,0.0,0.0);
    gun.setTexture(screen.getTextureID("Gun"));
    gun.setSize(3.5, 1.5, 1.0);
    screen.add(gun);
  }
  
  void setupSound(SFXEngine sound){
    gunsound = sound.getSound("gun");
  }

  void quit(){
    writefln("[ G ] Triggerpull bye");
  }
  
  void load(GameEngine engine){
    engine.requestUpdate(1.0);
    if(!exists(filename)){
      writefln("[ G ] No save game found: %s",filename);    
    }else{
      auto fp = new File(filename,"rb");
      string buffer;
      int cnt=0;
      fp.readln(buffer);
      buffer = chomp(buffer);
      string[] entities = buffer.split("\t");
      foreach(string e; entities){cnts ~= to!int(e); }
      fp.close();
      writefln("[ G ] %s loaded", filename);
    }
    writeln("[ G ] Triggerpull reloaded");
  }
  
  void save(){
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
    writefln("[ G ] Saved game to %s", filename);
  }
  
  void render(GFXEngine engine){
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
  
  void handle(Event e){
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
  
  void update(){
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
