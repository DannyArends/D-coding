module dcmp.instructionset;

import dcode.errors : abort;
import dcmp.cpu : Cpu;

enum cpuReg {EAX  = 0, EBX  = 1, ECX   = 2, EDX = 3 };
enum opType {NONE = 0, REG  = 1, IMM   = 2, MEM = 3 };
enum opSize {BYTE = 1, WORD = 2, DWORD = 3 };
enum opCode {PUSH = 1, POP  = 2, MOV   = 3, ADD = 4, JMP   = 5, RET = 6 };

struct Elem{
  ubyte[]   data = [0x0, 0x0, 0x0, 0x0];
  opSize    size = opSize.WORD;
}

struct Inst{
  opCode    opcode;
  opType[2] types;
  opSize    size;
  cpuReg[2] regs;
  Elem[2]   values;
}

void push(ref Cpu c, Inst i){ with(c){
  switch(i.types[0]){
    case opType.NONE : stack ~= Elem(); break;
    case opType.IMM  : stack ~= i.values[0]; break;
    case opType.REG  : stack ~= register[i.regs[0]]; break;
    case opType.MEM  : stack ~= memory[i.values[0]]; break;
    default: break;
  }
}}

void pop(ref Cpu c, Inst i){ with(c){
  if(stack.length == 0) abort("Cannot pop an empty stack");
  switch(i.types[0]){
    case opType.NONE : /* NO ERROR, JUST POP */ break;
    case opType.IMM  : abort("Cannot pop to immediate"); break;
    case opType.REG  : register[i.regs[0]] = stack[($-1)]; break;
    case opType.MEM  : memory[i.values[0]] = stack[($-1)]; break;
    default: break;
  }
  stack = stack[0 .. ($-1)];
}}

void mov(ref Cpu c, Inst i){}
void add(ref Cpu c, Inst i){}
void jmp(ref Cpu c, Inst i){}
void ret(ref Cpu c, Inst i){}

