/**********************************************************************
 * \file src/game/path.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.path;

import core.typedefs.types;
import std.array;
import std.conv;

alias Point Step;

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