/******************************************************************//**
 * \file src/game/search.d
 * \brief Search algorithms
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.search;

import core.thread;
import std.array;
import std.conv;
import std.math;
import std.string;
import std.datetime;
import core.time;

import core.arrays.types;
import game.searchnode;
import game.tilemap;
import game.mover;
import game.path;

interface SearchHeuristic {
public:
  double getCost(Mover mover, int x, int y, int tx, int ty);
}

class EuclideanEstimator : SearchHeuristic {
public:
  override double getCost(Mover mover, int x, int y, int tx, int ty) {
    double dx = tx - x;
    double dy = ty - y;
    return sqrt((dx*dx)+(dy*dy));
  }
}

class ManhattanEstimator : SearchHeuristic{
public:
  override double getCost(Mover mover, int x, int y, int tx, int ty) {
    double dx = abs(tx - x);
    double dy = abs(ty - y);
    return (dx+dy);
  }
}

class AStarSearch{
public:

  this(int sx,int sy,int tx,int ty,TileMap map){
    this(sx,sy,tx,ty,map,new EuclideanEstimator(),10);
  }
  
  this(int sx, int sy, int tx, int ty, TileMap map, SearchHeuristic heuristic, int maxDepth){
    this.heuristic=heuristic;
    this.map=map;
    nodes = newclassmatrix!Node(map.x, map.y);
    nodes[sx][sy] = new Node(0, 0);
    this.sx=sx;
    this.sy=sy;
    this.tx=tx;
    this.ty=ty;
    this.maxDepth=maxDepth;
    open ~= nodes[sx][sy];
  }
  
  void searchPath(uint msec){
    auto t0 = Clock.currTime();
    auto t1 = Clock.currTime();
    while((open.length != 0) && ((t1-t0) < dur!"msecs"(msec))) {
      Node current = getFirstInOpen();
      if (current == nodes[tx][ty]) { break; }
      removeFromOpen(current);
      addToClosed(current);
      
      for (int x=-1;x<2;x++) {
        for (int y=-1;y<2;y++) {
          if ((x == 0) && (y == 0)) {
            continue;
          }
          int xp = x + current.x;
          int yp = y + current.y;
          
          if (map.isValidLocation(mover,sx,sy,xp,yp)) {	
            int nextStepCost = cast(int) (current.getCost() + map.getMovementCost(mover, current.x, current.y, xp, yp));
            Node neighbour = nodes[xp][yp];
            map.pathFinderVisited(xp, yp);
            if (nextStepCost < neighbour.getCost()) {
              if (inOpenList(neighbour)) {
			    removeFromOpen(neighbour);
              }
              if (inClosedList(neighbour)) {
                removeFromClosed(neighbour);
              }
            }
								
			if (!inOpenList(neighbour) && !(inClosedList(neighbour))) {
              neighbour.setCost(nextStepCost);
              neighbour.setParent(current);
              neighbour.setEstimate(heuristic.getCost(mover, xp, yp, tx, ty));
              open ~= neighbour;
            }
          }
        }
      }
      open = mostLikelyOnTop(open);
      t1 = Clock.currTime();
    }
  }
  
  private Node[] mostLikelyOnTop(Node[] nodelist) {
    return nodelist;
  }
  
  Path getPath(){
    if (nodes[tx][ty].getParent() is null) return null;
		
    Path path = new Path();
    Node target = nodes[tx][ty];
    while (target != nodes[sx][sy]) {
      path.prependStep(target.x, target.y);
      target = target.getParent();
    }
    path.prependStep(sx,sy);
    return path;
  }
  
  bool inClosedList(Node n) {
    foreach(Node x; closed){
      if(n.x == x.x && n.y == x.y) return true;
    }
    return false;
  }

private:  
  bool inOpenList(Node n) {
    foreach(Node x ; open){
      if(n.x == x.x && n.y == x.y) return true;
    }
    return false;
  }
  
  Node getFirstInOpen(){
    return open[0];
  }
	
  void removeFromOpen(Node n){
    Node[] newopen;
    foreach(Node x; open){
      if(!(n.x == x.x && n.y == x.y)) newopen ~= x;
    }
    open = newopen;
  }
	
  void removeFromClosed(Node n){
    Node[] newclosed;
    foreach(Node x; closed){
      if(!(n.x == x.x && n.y == x.y)) newclosed ~= x;
    }
    closed = newclosed;
  }
	
  void addToClosed(Node n){
    closed ~= n;
  }
  
  SearchHeuristic heuristic;
  TileMap         map;
  Node[][]        nodes;
  Node[]          open;
  Node[]          closed;
  Mover           mover;
  int             maxDepth;
  int             sx,sy;
  int             tx,ty;
}
