/**
 * \file searchnode.d
 *
 * Copyright (c) 2010 Danny Arends
 * 
 **/

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