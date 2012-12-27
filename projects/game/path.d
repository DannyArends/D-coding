/**********************************************************************
 * \file src/game/path.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.path;

import std.array, std.conv;
import core.typedefs.types;

alias Point Step;

class Path{
  public:
    uint length(){ return cast(uint)steps.length; }
    void append(Step step){ steps = steps ~ step; }
    void prepend(Step step){ steps = step ~ steps; }
  
    bool contains(Step step){
      foreach(Step s ; steps){ if(s.x==step.x && s.y==step.y){ return true; } }
      return false;
    }
  
  private:
    Step[] steps;
}
