/**********************************************************************
 * \file src/game/searchnode.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.searchnode;

import core.thread;
import std.array;
import std.conv;

class Node{
public:
  int   x;
  int   y;
  
  this(){
  }
  
  this(int c, int d){
    cost=c;
    depth=d;
  }

  int setParent(Node p) {
    parent=p;
    return(depth+1);
  }
  
  Node getParent(){
    return parent;
  }
  
  double getCost(){ return cost; }
  void setCost(double c){ cost = c; }
  
  double getEstimate(){ return hcost; }
  void setEstimate(double h){ hcost=h; }
  
private:
  double cost    = 0;
  double hcost   = 0;
  int    depth   = 0;
  Node   parent  = null;
}