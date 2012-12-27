/******************************************************************//**
 * \file src/core/executor.d
 * \brief Execute commands via the commandline 
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jun, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module ostest.executor;
import dcode.stdinc, dcode.types;

extern (C) int system(char *);

struct ExecResult{
 int      status;
 string   std_out;
 string   std_err;
}

struct ExecProg{
  string    name;
  string    command;
  string    arguments;
  bool      available = false;
}

class Executor{
  private:
  bool     verbose;
  string   stdoutfile;
  string   stderrfile;
  string   command;
  int      status;
  
  public:
  this(int id, bool verbose = true){
    this.stdoutfile = "tmp_" ~ to!string(id) ~ ".out";
    this.stderrfile = "tmp_" ~ to!string(id) ~ ".err";
    this.verbose = verbose;
    if(verbose)writeln("Executor constructed");
  }
  
  ExecResult execute(string command, string arguments =""){
    version(Windows){
      command = "\"call \"" ~ command ~ "\" " ~ arguments ~"\" > " ~ stdoutfile ~ " 2> "~ stderrfile;    
    }else{
      command = command ~ " " ~ arguments ~ " > " ~ stdoutfile ~ " 2> "~ stderrfile;
    }
    ExecResult result;
    if(verbose) writeln("command: " ~ command);
    result.status = system(toUTFz!(char*)(command));
    if(exists(stdoutfile)){
      result.std_out = readText(stdoutfile);
      remove(stdoutfile);
      if(verbose) writeln("std_out: " ~ to!string(result.status) ~ " " ~to!string(result.std_out.length));
    }
    if(exists(stderrfile)){
      result.std_err = readText(stderrfile);
      remove(stderrfile);
      if(verbose) writeln("std_err: " ~ to!string(result.status) ~ " " ~to!string(result.std_err.length));
    }
    return result;
  }
}

