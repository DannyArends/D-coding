module dcmp.codegen_asm;

import std.stdio;
import dcmp.errors, dcmp.functions;

immutable string user_entry = "_umain";

string[] variables;
string[] labels;

void prolog(){
  writeln("global main");
  writeln("section .text\n");
  writeln("main:");  
}

void moveRegister(string from = "eax", string reg = "eax"){ writefln("\t\tmov  %s,%s", from, reg); }
void clearRegister(string reg = "eax"){ writefln("\t\tclr   %s", reg); }
void negateRegister(string reg = "eax"){ writefln("\t\tneg   %s", reg); }
void loadConstant(string n, string reg = "eax"){ writefln("\t\tmov   %s, %s", reg, n); }
void pushRegister(string reg = "eax"){ writefln("\t\tpush  %s", reg); }
void popRegister(string reg = "eax"){ writefln("\t\tpop   %s", reg); }
void popAdd(string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tadd   eax, ebx");
}

void popSub(string reg = "eax"){
  popRegister("ebx");
  negateRegister("ebx");
  writeln("\t\tadd   eax, ebx");
}

void popMul(string reg = "eax"){
  popRegister("ebx");
  writeln("\t\timul  eax, ebx");
}

void popDiv(string reg = "eax"){
  popRegister("ecx");
  loadConstant("0", "edx");
  writeln("\t\tidiv  ecx");  
}

/* Load a variable in register reg */
void loadVariable(string name, string reg = "eax"){
  if(!inTable(name, variables)) undefined(name);
  writefln("\t\tmov   %s, [%s]", reg, name);
}

/* Store register reg in a variable */
void storeVariable(string name, string reg = "eax"){
  if(!inTable(name, variables)) undefined(name);
  writefln("\t\tmov   [%s], %s", name, reg);
}

/* Emit a jump to a label */
void jmpToLabel(string label){
  if(!inTable(label, labels)) undefined(label);
  writefln("\t\tjmp   %s", label);
}

/* Emit a function call */
void callFunction(string label){
  if(!inTable(label, labels)) undefined(label);
  writefln("\t\tcall  %s", label);
}

/* Add a label and emits a jump to the endlabel (if jump = true) */
string addLabel(string label, bool jump = false){
  if(label == "main") label = user_entry;         // We use main to set-up the global environment
  if(inTable(label, labels)) duplicate(label);    // Don't allow duplicate labels
  if(jump) writefln("\t\tjmp   %s_end",label);
  writefln("%s:", label);
  labels ~= label;
  return label;
}

/* Prolog of a function, allows for local stack variables aligned to ebp */
void functionProlog(string space = "0"){
  writeln("\t\tpush  ebp");                       // Establishing stack-frame
  writeln("\t\tmov   ebp, esp");
  writefln("\t\tsub   esp, %s", space);           // Stack space local variables [ebp-4] [ebp-8] [ebp-12]
}

/* Restore the previous stack context */
void functionEpilog(){
  writeln("\t\tmov   esp, ebp");
  writeln("\t\tpop   ebp");                       // Unwinding stack-frame
  writeln("\t\tret");
}

/* Allocate a variable (so that it is added to the data section) */
void allocateVariable(string name){               // Allocate a variable
  if(inTable(name, variables)) duplicate(name);
  variables ~= name;
}

void epilog(){
 writefln("\t\tcall  %s", user_entry);           // Call the user entry (Should return result to EAX)
	writeln("\t\tmov   eax, 0");                    // Normal, no error, return value
	writeln("\t\tret\n");

  writeln("section .data");                       // All 'global' variables
  foreach(name; variables){ writefln("\t%s:  dd 0", name); }
}

