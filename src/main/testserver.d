/******************************************************************//**
 * \file src/main/testserver.d
 * \brief Shared library loader
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written Apr, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio, std.math, std.conv, std.string, std.array;
import std.concurrency, std.conv;
import core.time, core.thread, core.terminal;
import web.socketclient;

alias core.thread.Thread Thread;

mixin(GenOutput!("TO", "Green"));
mixin(GenOutput!("FROM", "Orange"));

class MyReader : Thread{
  this(){
    network = new SocketClient("localhost",3000);
    super(&run);
  }
    
  void run(){
    online = network.connect();
    while(online){
      string s = chomp(network.read(1));
      if(s !is null && s.length >= 1){
      try{
        foreach(string cmd ; s.split("\0")){
          if(cmd !is null && cmd.length >= 1){
            if(cmd.length > 100){
             cmd = cmd[0..50] ~ ".." ~ cmd[($-50)..$];
            }
            wFROM("%s",chomp(cmd));
          }
        }
      }catch(Throwable exception){
        ERR("Unable to handle command: %s",s);
      }
    }
    Thread.sleep( dur!("msecs")( 10 ) );
    }
    network.disconnect();
  }
  
  shared bool online;
  SocketClient network;
}

string[] cmds = [ "C#help",
  "C#login Test Test", /*Should fail*/ "C#create Test Test",
  "C#login Test Test", /*Should fail*/ "C#help",
  "C#stats", "M-10:10:9", "C#logout", "C#login Test Test",
  "M4:0:9","M1:0:9","M4:0:4", "C#delete_me", "CSome random text",
  "C#delete_me", "C#delete_me",
  "C#help",
  "C#login Test Test", /*Should fail*/ "C#create Test Test",
  "C#chpass Test Test1 Test1", "C#logout",
  "C#login Test Test1", "CChat by Test",
  "C#chname Tes Test1", "C#logout", "C#login Tes Test1",
  "CChat by Tes", "C#delete_me", "C#delete_me",
  "C#help"];

void main(string[] args){
  MSG("Server test v0.1");
  MyReader r = new MyReader();
  r.start();
  Thread.sleep( dur!("msecs")( 1500 ) );
  char[] buf;
  int cnt = 0;
  while(r.online){
    if(cnt < cmds.length){
      wTO("%s",cmds[cnt]);
      r.network.write(cmds[cnt] ~ "\0");
      Thread.sleep( dur!("msecs")( 300 ) );
    }else{
      r.online=false;
    }
    cnt++;
  }
  MSG("Network closing down");
}
