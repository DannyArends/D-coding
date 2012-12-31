module dcmp.codegen_386;

import std.stdio;
import dcmp.errors, dcmp.functions;

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

void loadVariable(string name, string reg = "eax"){
  if(!inTable(name, variables)) undefined(name);
  writefln("\t\tmov   %s, [%s]", reg, name);
}

void storeVariable(string name, string reg = "eax"){
  if(!inTable(name, variables)) undefined(name);
  writefln("\t\tmov   [%s], %s", name, reg);
}

void jmpToLabel(string label){
  if(!inTable(label, labels)) undefined(label);
  writefln("\t\tjmp   %s", label);
}

void callFunction(string label){
  if(!inTable(label, labels)) undefined(label);
  writefln("\t\tcall  %s", label);
}

void returnFunction(){
	writeln("\t\tret");
}

string addLabel(string label, bool jump = false){
  if(label == "main") label = "_entry";         // We use main to set-up the global environment
  if(inTable(label, labels)) duplicate(label);  // Don't allow duplicate labels
  if(jump) writefln("\t\tjmp %s_end",label);
  writefln("%s:", label);
  labels ~= label;
  return label;
}

void allocateVariable(string name){ // allocate a variable
  if(inTable(name, variables)) duplicate(name);
  variables ~= name;
}

void epilog(){
	writeln("\t\tcall  _entry"); // Call the user main
	writeln("\t\tmov   eax, 0"); // Normal, no error, return value
	writeln("\t\tret");
  writeln("section .data");
  foreach(name; variables){
    writefln("\t%s:  dd 0", name);
  }
}

