module dcmp.cpu;
import std.c.stdlib, std.stdio, std.file, std.string, std.array;
import dcmp.errors, dcmp.instructionset;

enum cpuReg {EAX  = 0, EBX  = 1, ECX   = 2, EDX = 3 };
enum opType {NONE = 0, REG  = 1, IMM   = 2, MEM = 3 };
enum opSize {BYTE = 1, WORD = 2, DWORD = 3 };
enum opCode {PUSH = 1, POP  = 2, MOV   = 3, ADD = 4, JMP   = 5, RET = 6 };

struct Inst{
  opCode    opcode;
  opType[2] types;
  opSize    size;
  cpuReg[2] regs;
  Elem[2]   values;
}

alias void function(ref Cpu c, Inst i) InstFun;
InstFun[uint] instructionset;

static this(){ with(opCode){
  instructionset = [ 
    PUSH : &push, POP  : &pop, MOV  : &mov, 
    ADD  : &add,  JMP  : &jmp, RET  : &ret
  ];
}}

struct Elem{
  ubyte[]   data = [0x0, 0x0, 0x0, 0x0];
  opSize    size = opSize.WORD;
}

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

