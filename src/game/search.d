/******************************************************************//**
 * \file src/game/search.d
 * \brief A* Search and distance algorithms
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.search;

import core.thread, std.array, std.conv, std.stdio, std.math;
import std.string, std.datetime, core.time;
import core.arrays.types;
import game.searchnode, game.tilemap, game.mover,game.path;

/*! \brief SearchHeuristic interface definition
 *
 * Interface SearchHeuristic definition
 */
interface SearchHeuristic {
public:
  double getCost(Mover mover, int x, int y, int tx, int ty);
}

/*! \brief Euclidean distance estimator
 *
 * Calculate Euclidean distance, helper class for A* search
 */
class EuclideanEstimator : SearchHeuristic {
public:
  override double getCost(Mover mover, int x, int y, int tx, int ty) {
    double dx = tx - x;
    double dy = ty - y;
    return sqrt((dx*dx)+(dy*dy));
  }
}

/*! \brief Manhattan distance estimator
 *
 * Calculate Manhattan distance, helper class for A* search
 */
class ManhattanEstimator : SearchHeuristic{
public:
  override double getCost(Mover mover, int x, int y, int tx, int ty) {
    double dx = abs(tx - x);
    double dy = abs(ty - y);
    return (dx+dy);
  }
}

/*! \brief A* search implementation in D
 *
 * A* search implementation in D
 */
class AStarSearch{
  public:

    this(int sx,int sy,int tx,int ty,TileMap map){
      this(sx,sy,tx,ty,map,new EuclideanEstimator(),10);
    }
    
    this(int sx, int sy, int tx, int ty, TileMap map, SearchHeuristic heuristic, int maxDepth){
      this.heuristic=heuristic;
      this.map=map;
      for(int x=0;x<map.x;x++){
        Node[] nlist;
        for(size_t y=0;y<map.y;y++){
          nlist ~= new Node(x,y);
        }
        nodes ~= nlist;
      }
      this.sx=sx;
      this.sy=sy;
      this.tx=tx;
      this.ty=ty;
      this.maxDepth=maxDepth;
      open ~= nodes[sx][sy];
      writeln("[SEARCH] CONSTRUCTED [",sx," ",sy,"] [",tx," ",ty,"]");
    }
    
    long searchPath(long msec){
      writeln("[SEARCH] STARTED");
      auto t0 = Clock.currTime();
      auto t1 = Clock.currTime();
      while((t1-t0).total!"msecs" < msec){
        if((open.length != 0)){
          debug writeln("[SEARCH] Open length: ",open.length);
          Node current = getFirstInOpen();
          if(current.x == tx && current.y==ty){ writeln("[SEARCH] DONE, at destination");
            return(msec - (t1-t0).total!"msecs");
          }
          removeFromOpen(current);
          debug writeln("[SEARCH] Open length: ",open.length);
          addToClosed(current);
          debug writeln("[SEARCH] Closed length: ",closed.length);
          debug writeln("[SEARCH] Adding neighbouring squares");
          for(int x=-1;x<2;x++){
            for(int y=-1;y<2;y++){
              if((x == 0) && (y == 0)){ continue; } //Current tile
              
              int xp = x + current.x;
              int yp = y + current.y;
              
              if(map.isValidLocation(mover,sx,sy,xp,yp)){
                int nextStepCost = cast(int) (current.getCost() + map.getMovementCost(mover, current.x, current.y, xp, yp));
                Node neighbour = nodes[xp][yp];
                map.pathFinderVisited(xp, yp);
                if(nextStepCost < neighbour.getCost()){
                  if(inOpenList(neighbour)){
                    removeFromOpen(neighbour);
                  }
                  if(inClosedList(neighbour)){
                    removeFromClosed(neighbour);
                  }
                }
                if(!inOpenList(neighbour) && !(inClosedList(neighbour))){
                  neighbour.setCost(nextStepCost);
                  neighbour.setParent(current);
                  neighbour.setEstimate(heuristic.getCost(mover, xp, yp, tx, ty));
                  open ~= neighbour;
                }
              }
            }
          }
          debug writeln("[SEARCH] Resorting open:",open.length);
          open = mostLikelyOnTop(open);
        }else{
          writeln("[SEARCH] DONE, no more options");
          return(msec - (t1-t0).total!"msecs");
        }
        t1 = Clock.currTime();
      }
      writeln("[SEARCH] DONE, search time expired");
      return 0;
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
    
  private:  
    Node[] mostLikelyOnTop(Node[] nodelist){
      return nodelist;
    }

    bool inClosedList(Node n){
      foreach(Node x; closed){
        if(n.x == x.x && n.y == x.y) return true;
      }
      return false;
    }

    
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
