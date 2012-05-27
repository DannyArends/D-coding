/**********************************************************************
 * \file src/game/games/empty.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written May, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module game.games.empty;

import std.stdio;
import core.arrays.algebra, core.events.engine;
import game.engine, gui.stdinc, sfx.engine;

class Empty : Game{
  public:
  override void setup2D(Screen screen){ wGAME("Done with 2D setup"); }
  override void setup3D(Screen screen){ wGAME("Done with 3D setup"); }
  override void setupSound(SFXEngine sound){ wGAME("Done with sound setup"); }
  override void quit(){ wGAME("Received: QUIT"); }  
  override void load(){ wGAME("Received: LOAD"); }
  override void save(){ wGAME("Received: SAVE"); }
  override void render(GFXEngine engine){ }  
  override void handle(Event e){ wGAME("Received: EVENT"); }
}
