module dpart;
import std.stdio;

version(linux){
  int main(){ 
    return 0; 
  }
}

extern (C) bool  rt_init( void delegate( Exception ) dg = null );
extern (C) bool  rt_term( void delegate( Exception ) dg = null );

extern(C):

int Process(int Value){
  writeln("You have sent the value: ", Value);
  int ResultD = (Value % 5);
  return ResultD;
}

void LinuxInit(){
  version(linux)
  main();
}
