module dcmp.cpu;

import std.stdio            : writefln;
import dcmp.instructionset  : Elem, Inst, opCode, push, pop, mov, add, jmp, ret;


alias void function(ref Cpu c, Inst i) InstFun;
InstFun[uint] instructionset;

static this(){ with(opCode){
  instructionset = [ 
    PUSH : &push, POP  : &pop, MOV  : &mov, 
    ADD  : &add,  JMP  : &jmp, RET  : &ret
  ];
}}

struct Cpu{
  Elem register[4];
  Elem stack[];
  Elem memory[Elem];
  Inst instructions[];
}

void execute(ref Cpu c){ with(c){
  while(instructions.length > 0){
    c.execute(instructions[0]);
  }
}}

void execute(ref Cpu c, Inst i){ with(c){
  instructionset[i.opcode](c, i);
  instructions = instructions[1 .. $];
}}

void main(string[] args){
  Cpu c = Cpu();
  c.instructions ~= Inst(opCode.PUSH);
  c.instructions ~= Inst(opCode.PUSH);
  c.instructions ~= Inst(opCode.PUSH);
  c.instructions ~= Inst(opCode.POP);
  c.instructions ~= Inst(opCode.POP);

  c.execute();
  writefln("%s", c);
}

