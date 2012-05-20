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

import std.array, std.conv;
import core.typedefs.types;

/*! \brief A* search Node class
 *
 *  Internal A* search Node class
 */
class Node{
public:  
  this(int x, int y, int c=0, int d=0){
    loc = Point(x,y);
    mcost=c;
    depth=d;
  }

  int setParent(Node p){ parent=p; return(depth+1); }
  Node getParent(){ return parent; }
  
  @property double cost(double c = double.init){ if(c !is double.init){ mcost=c; } return mcost; }  
  @property double estimate(double h = double.init){ if(h !is double.init){ hcost=h; } return hcost; }
  @property int x(){ return loc.x; }      //!< X location of the Node
  @property int y(){ return loc.y; }      //!< Y location of the Node

private:
  Point  loc;
  double mcost    = 0;
  double hcost   = 0;
  int    depth   = 0;
  Node   parent  = null;
}
