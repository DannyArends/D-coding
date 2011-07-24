/**
 * \file path.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

module game.path;

import core.thread;
import std.array;
import std.conv;

struct Step{
  int x;
  int y;
  
  this(int x, int y){
    this.x=x;
    this.y=y;
  }
}

class Path{

public:
  uint getLength(){
    return cast(uint)steps.length;
  }

  void appendStep(int x, int y){
    steps = steps ~ Step(x,y);
  }
  
  void prependStep(int x, int y){
    steps = Step(x,y) ~ steps;
  }
  
  bool contains(int x, int y){
    foreach(Step s ; steps){
      if(s.x==x && s.y==y) return true;
    }
    return false;
  }
  
private:
  Step[] steps;

}