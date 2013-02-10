module dcmp.instructionset;

import std.stdio;
import dcode.errors;
import dcmp.cpu;

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

