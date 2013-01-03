module dcmp.codegen_asm;

import std.stdio;
import dcmp.errors, dcmp.functions;

immutable string user_entry = "_umain";

string[] variables;
string[] labels;

void prolog(){
  writeln("global main");
  writeln("extern printf");
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
  negateRegister("eax");
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

void andBoolean(string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tand   eax, ebx");
}

void orBoolean(string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tor   eax, ebx");
}

void pushBoolean(string value = "true"){
  if(value == "true"){
    loadConstant("1");
  }else{ loadConstant("0"); }
}

void emitTest(string label){
  writeln("\t\tcmp   eax, 0");
  writefln("\t\tjz  %s", label);
}

void negateBoolean(string reg = "eax"){ writeln("\t\txor   eax, 1"); }

void popEquals(string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tcmp   eax, ebx");
  writeln("\t\tsete  al");
}

void popNotEquals(string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tcmp   eax, ebx");
  writeln("\t\tsetne al");
}

void popSmaller(bool equal = false, string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tcmp    eax, ebx");
  string cmd = "setnle";
  if(equal) cmd = "setnl";
  writefln("\t\t%s al", cmd);
}

void popLarger(bool equal = false, string reg = "eax"){
  popRegister("ebx");
  writeln("\t\tcmp    ebx, eax");
  string cmd = "setnge";  
  if(equal) cmd = "setng";
  writefln("\t\t%s al", cmd);
}

/* Load a variable in register reg */
void loadVariable(string name, bool push = false, string reg = "eax"){
  if(!inTable(name, variables)) undefined(name);
  writefln("\t\tmov   %s, [%s]", reg, name);
  if(push) writefln("\t\tpush   %s", reg);
}

/* Loads an argument passed to use in register reg */
void loadLocalArgument(string offset, string reg = "eax"){
  writefln("\t\tmov   %s, [ebp + %s]", reg, offset);
}

/* Store register reg in a variable */
void storeVariable(string name, bool push = false, string reg = "eax"){
  if(!inTable(name, variables)) undefined(name);
  writefln("\t\tmov   [%s], %s", name, reg);
  if(push) writefln("\t\tpush   %s", reg);
}

/* Emit a jump to a label */
void jmpToLabel(string label, bool check = true){
  if(check && !inTable(label, labels)) undefined(label);
  writefln("\t\tjmp   %s", label);
}

/* Emit a function call */
void callFunction(string label){
  if(label == "print") return printf();
  if(label == "exit") return exit("0");
  if(label == "return") return functionEpilog();
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

/* Small hack to have some output */
void printf(){                                   // Should be changed to something like:
  writeln("\t\tpush  eax");                      // mov eax, 4      ; write
  writeln("\t\tpush  _formatI");                 // mov ebx, 1      ; to the standard output
  writeln("\t\tcall  printf");                   // mov ecx, msg	  ; Name of the variable to write
  writeln("\t\tadd   esp, 8");                   // mov edx, length ; length of variable in bytes
}                                                // int 0×8         ; invoke an interrupt

/* Exit from the program using an interupt */
void exit(string code){
  writeln("\t\tmov   eax, 1");
  writefln("\t\tmov   ebx, %s", code);
  writeln("\t\tint   0x80");
}

/* Write the program's epilog */
void epilog(){
  if(inTable(user_entry, labels)){
    writefln("\t\tcall  %s", user_entry);         // Call the user entry (Should return result to EAX)
	}else{
    writeln("\t\tmov   eax, 0");                  // Normal, no error, return value
  }
	writeln("\t\tret\n");

  writeln("section .data");                       // All 'global' variables
  foreach(name; variables){ writefln("\t%s:  dd 0", name); }
  writeln("\t_newline:  db  0xA, 0");
  writeln("\t_formatI:  db  '%d', 0xA, 0");
  writeln("\t_formatF:  db  '%f', 0xA, 0");
}

