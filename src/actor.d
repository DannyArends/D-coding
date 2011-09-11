import std.concurrency;
import std.stdio;
import core.thread;
import std.random;
import std.typecons;

struct Message{
  int        senderid;
  shared Tid sender;
  int        payload;
}

int main(){
  bool verbose = false;
  int id=1;
  foreach(j; 0 .. 700){
    auto tid1 = spawn(&worker,id,verbose);
    id++;
    foreach(i; 0 .. 101){
      tid1.send(Message(0,cast(shared)thisTid(),i));   // send some integers
    }
  }
  
  bool active = true; 
  while(active){
    receive(
      (Message m){
        if(verbose)writefln("Main received a msg %d: %d", m.senderid, m.payload);
        if(m.payload==100){
          writefln("Thread with id %d handled all messages",m.senderid);
          active = false;  
        }
      },
      (Variant v){ 
        writefln("Unsupported message %s",v); 
      }
    );  
  }
  return 0;
}
 
void worker(int id, bool verbose){
  bool active = true;  
  while(active){
    receive(
      (Message m){
        if(verbose) writeln("Unpacking shared reference to main");
        Tid s = cast(Tid)m.sender;
        if(verbose) writeln("Sending a msg to main");  
        s.send(Message(id,cast(shared)thisTid(),m.payload));
        if(m.payload==100){
          active = false;
        }
        Thread.sleep(uniform(0, 70000));
      },
      (Variant v){ 
        writefln("Unsupported message %s",v); 
      }
    );
  }
}