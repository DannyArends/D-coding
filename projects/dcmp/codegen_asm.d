module dcmp.codegen_asm;

import std.stdio;
import dcmp.errors, dcmp.variables, dcmp.functions, dcmp.procedures;

immutable string user_entry = "_umain";

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
  writeln("\t\tcmp   al, 0");
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
  writeln("\t\tcmp    eax, ebx");
  string cmd = "setnge";  
  if(equal) cmd = "setng";
  writefln("\t\t%s al", cmd);
}

/* Load a variable v in register reg */
void loadVariable(Variable v, int offset = -1, string reg = "eax"){
  if(!inTable(v.name, getVariables())) undefined(v.name);
  if(v.loc == "global"){
    if(offset < 1) return writefln("\t\tmov   %s, [%s]", reg, v.name);
    writefln("\t\tmov   %s, [%s + %s]", reg, v.name, offset);
  } else if(v.loc == "local") {    
    writefln("\t\tmov   %s, [ebp - %s]", reg, v.offset + offset);
  } else if(v.loc == "argument") {
    int toff = getOffset(functions[($-1)].vscope,"argument") + 4;
    writefln("\t\tmov   %s, [ebp + %s]", reg, toff - v.offset + offset);
  }

}

/* Store register reg in variable v */
void storeVariable(Variable v, int offset = -1, string reg = "eax"){
  if(!inTable(v.name, getVariables())) undefined(v.name);
  if(v.loc == "global"){
    if(offset < 1) return writefln("\t\tmov   [%s], %s", v.name, reg);
    writefln("\t\tmov   [%s + %s], %s", v.name, offset, reg);
  } else if(v.loc == "local") {
    writefln("\t\tmov   [ebp - %s], %s", v.offset + offset, reg);
  } else if(v.loc == "argument") {
    writefln("\t\tmov   [ebp + %s], %s", v.offset + offset, reg);
  }
}

/* Emit a jump to a label */
void jmpToLabel(string label, bool check = true){
  if(check && !inTable(label, labels)) undefined("label:" ~ label);
  writefln("\t\tjmp   %s", label);
}

/* Emit a function call */
void callFunction(string label){
  if(label == "printf") return printf("F");
  if(label == "printc") return printf("C");
  if(label == "print") return printf();
  if(label == "exit") return exit("0");
  if(label == "return") return functionEpilog();
  if(!inTable(label, labels)) undefined("label:" ~ label);
  writefln("\t\tcall  %s", label);
}

/* Add a label and emits a jump to the endlabel (if jump = true) */
string addLabel(string label, bool jump = false){
  if(label == "main") label = user_entry;         // We use main to set-up the global environment
  if(inTable(label, labels)) duplicate("label:" ~ label);    // Don't allow duplicate labels
  if(jump) writefln("\t\tjmp   %s_end",label);
  writefln("%s:", label);
  labels ~= label;
  return label;
}

/* Prolog of a function, allows for local stack variables aligned to ebp */
void functionProlog(string space = "512"){
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

/* Small hack to have some output */
void printf(string type = "I"){                  // Should be changed to something like:
  writeln("\t\tpush  eax");                      // mov eax, 4      ; write
  writefln("\t\tpush  _format%s", type);         // mov ebx, 1      ; to the standard output
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

  writeln("section .bss");                        // Global variables go to '.bss' section
  foreach(v; variables){ writefln("\t%s: resb %s", v.name, v.bytesize); }

  writeln("section .data");                       // Static is stored in the .data section
  writeln("\t_newline:  db  0xA, 0");
  writeln("\t_formatC:  db  '%c', 0xA, 0");
  writeln("\t_formatI:  db  '%d', 0xA, 0");
  writeln("\t_formatF:  db  '%f', 0xA, 0");
}

