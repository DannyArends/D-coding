/******************************************************************//**
 * \file src/game/searchnode.d
 * \brief Internal A* searchnode definition
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Feb, 2012<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.searchnode;

import core.thread;
import std.array;
import std.conv;

/*! \brief A* search Node class
 *
 *  Internal A* search Node class
 */
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