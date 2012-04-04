/******************************************************************//**
 * \file src/core/events/clockevents.d
 * \brief Periodic Event and ClockEventHandler
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Feb, 2012<br>
 * First written Dec, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.events.clockevents;

import std.array;
import std.stdio;
import std.conv;
import std.datetime;

import core.typedefs.types;
import core.events.engine;

alias void delegate(int, int) FUN;

/*! \brief A periodic Event
 *
 *  Representation of a periodic Event, with adjustable timer
 */
class ClockEvent : Event {
  this(FUN toexecute, int period = 1000, int times = 1, bool verbose = true){
    this.times  = times;
    this.period = period;
    this.toexecute = toexecute;
    this.t0 = Clock.currTime();
    this.verbose = verbose;
  }
  
  EventType getEventType(){
    return EventType.CLOCK;
  }
  
  void resetAge(){
    super.resetAge();
    checks = 0;
    times--;
  }
  
  int period = 1000;         /* 1 second */
  FUN toexecute;             /* what do we execute */
  int times  = 0;            /* How many times */
  int checks = 0;            /* Number of times we check */
}

/*! \brief EventHandler for the ClockEvent class
 *
 *  EventHandler for the ClockEvent class
 */
class ClockEventHandler : EventHandler{
  public:
    
    void update(){
      super.update();
      for(auto x = 0; x < eventqueue.length;x++){
        if(eventqueue[x].getEventType()==EventType.CLOCK){
          ClockEvent ce = cast(ClockEvent)eventqueue[x];
          ce.checks++;
          if(ce.getAge() >= ce.period) {
            if(ce.verbose) writeln("[EVT] Executing ", ce.toexecute, " after ", ce.checks, " after ", ce.times);
            ce.toexecute(ce.checks, ce.times);
            ce.resetAge();
          }
          if(ce.times==0) ce.handled=true;
        }
      }
    }
    SysTime getTN(){ return Clock.currTime(); }
    SysTime getT0(){ return t0; }
    void setT0(){t0 = Clock.currTime(); }
  private:
    SysTime t0;
}
