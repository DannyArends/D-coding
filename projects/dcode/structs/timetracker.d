module dcode.timetracker;

import std.stdio, std.file, std.conv, std.string, std.random;
import core.memory;

struct TimeTracker{
  private:
    int[] mytime  = [0,0,0,1,1,1];
  
  public:
    void load(string filename = "ST.save"){
      if(!exists(filename)){
        writefln("Server time not found: '%s'",filename);    
      }else{
        auto fp = new File(filename,"rb");
        string buffer;
        fp.readln(buffer);
        fromString(chomp(buffer));
        fp.close();
        writefln("Server time loaded from '%s'", filename);
      }
    }
    
    void fromString(string msg){
      string[] dt = msg.split(" ");
      string[] entities = dt[1].split(":");
      size_t cnt=0;
      for(int x = 2; x >= 0; x--){ mytime[cnt] = to!int(entities[x]); cnt++; }
      entities = dt[0].split("-");
      for(int x = 2; x >= 0; x--){ mytime[cnt] = to!int(entities[x]); cnt++; }
    }
    
    void save(string filename = "ST.save"){
      auto fp = new File(filename,"wb");
      fp.writeln(val);
      fp.close();
      writefln("Server time saved to '%s'", filename);
    }
    
    void addSecond(){
      mytime[0]++;
      if(mytime[0] > 59){ mytime[1]++; mytime[0]=0; }
      if(mytime[1] > 59){ mytime[2]++; mytime[1]=0; }
      if(mytime[2] > 23){ mytime[3]++; mytime[2]=0; }
      if(mytime[3] > 30){ mytime[4]++; mytime[3]=1; }
      if(mytime[4] > 12){ mytime[5]++; mytime[4]=1; }
    }
    
    @property string val(){
      return  toD(mytime[3],2) ~ "-" ~ toD(mytime[4],2) ~ "-" ~ toD(mytime[5],4) ~ " " ~
              toD(mytime[2],2) ~ ":" ~ toD(mytime[1],2) ~ ":" ~ toD(mytime[0],2);
    }    
    @property string time(){
      return toD(mytime[2],2) ~ ":" ~ toD(mytime[1],2) ~ ":" ~ toD(mytime[0],2);
    }
    @property string day(){
      return  toD(mytime[3],2) ~ "-" ~ toD(mytime[4],2) ~ "-" ~ toD(mytime[5],4);
    }
}

