/******************************************************************//**
 * \file src/main/testserver.d
 * \brief Shared library loader
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Apr, 2012<br>
 * First written Apr, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.math;
import std.conv;
import std.string;
import std.array;
import std.concurrency;
import std.conv;

import core.time;
import core.thread;

import web.socketclient;

alias core.thread.Thread Thread;

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
            writeln("<<<--- ",chomp(cmd).replace("\n","\n<<<--- "));
          }
        }
      }catch(Throwable exception){
        writeln("[NET] Unable to handle command:",s,"\n",exception);
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
  "M4:0:9", "C#delete_me", "CSome random text",
  "C#delete_me", "C#delete_me",
  "C#help",
  "C#login Test Test", /*Should fail*/ "C#create Test Test",
  "C#chpass Test Test1 Test1", "C#logout",
  "C#login Test Test1", "CChat by Test",
  "C#chname Tes Test1", "C#logout", "C#login Tes Test1",
  "CChat by Tes", "C#delete_me", "C#delete_me",
  "C#help"];

void main(string[] args){
  MyReader r = new MyReader();
  r.start();
  Thread.sleep( dur!("msecs")( 1500 ) );
  char[] buf;
  int cnt = 0;
  while(r.online){
    if(cnt < cmds.length){
      writeln("\n--->>> ",cmds[cnt]);
      r.network.write(cmds[cnt] ~ "\0");
      Thread.sleep( dur!("msecs")( 300 ) );
    }else{
//      stdin.readln(buf);
//      if(chomp(to!string(buf)) == "quit"){
        r.online=false;
        Thread.sleep( dur!("msecs")( 100 ) );
//      }else{
//        r.network.write(to!string(buf));
//        writeln(buf);
//      }
    }
    cnt++;
  }
  writeln("[NET] Network closing down");
}
