/**********************************************************************
 * \file src/core/io/executor.d
 *
 * copyright (c) 2012 Danny Arends
 * last modified Feb, 2012
 * first written Jun, 2011
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
module core.io.executor;

import core.thread;
import std.file;
import std.path;
import std.conv;
import std.socket;
import std.stdio;
import core.typedefs.types;

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

class ExecEnvironment{
  public:
  this(){
    progs ~= ExecProg("DMD compiler for D programming language","dmd","-v");
    progs ~= ExecProg("GCC compiler for C++","g++","-v");
    progs ~= ExecProg("GCC compiler for C","gcc","-v");
    progs ~= ExecProg("R statistical language","R","--version");
    progs ~= ExecProg("Java virtual machine","java","");
    progs ~= ExecProg("Javac compiler for Java","javac","");
    progs ~= ExecProg("Java ANT builder","ant","");
    progs ~= ExecProg("Perl interpreter","perl","-v");
    progs ~= ExecProg("Python interpreter","python","-h");
    progs ~= ExecProg("Ruby programming language","ruby","-v");
        
    progs ~= ExecProg("SVN repository support","svn","");
    progs ~= ExecProg("Git repository support","git","");
    progs ~= ExecProg("CVS repository support","cvs","");
    
    progs ~= ExecProg("Latex documentation tool","latex","--help");
    progs ~= ExecProg("WGET communication","wget","");
    progs ~= ExecProg("SSH communication","ssh","--v");
    progs ~= ExecProg("FTP communication","ftp","--help");
    progs ~= ExecProg("SH - Unix command shell","sh","--v");

    progs ~= ExecProg("qsub - PBS job submission","qsub","-v");
    progs ~= ExecProg("qstat - PBS job monitoring","qstat","");

    progs ~= ExecProg("find - Find command line tool","find","/?");
    progs ~= ExecProg("ping - Ping command line tool","ping","");
    progs ~= ExecProg("grep - Grep commandline toolset","grep","");
    
    version(Windows){
      progs ~= ExecProg("tasklist - Win32 process monitoring","tasklist","");
      progs ~= ExecProg("taskkill - Kill a Win32 process","taskkill","");
      progs ~= ExecProg("fc - File comparison tool","fc","");
      progs ~= ExecProg("type - Open text files","type","/?");
    }else{
      progs ~= ExecProg("ps - Unix process monitoring","ps","");    
      progs ~= ExecProg("kill - Kill a Unix process","kill","");
      progs ~= ExecProg("diff - File comparison tool","diff","");
      progs ~= ExecProg("cat - Open text files","cat","");
    }
  }
  
  void detectEnvironment(bool verbose = false){
    Executor detector = new Executor(1);
    int detect = detector.execute("aaaa").std_err.length - 4;
    for(auto x=0;x < progs.length;x++){
      if(verbose) writeln("Testing for: " ~ progs[x].name);
      progs[x].available = detector.execute(progs[x].command,progs[x].arguments).std_err.length != detect+progs[x].command.length;
    }
  }
  
  bool hasCommand(string cmd){
    foreach(ExecProg p; progs){
      if(p.available) if(p.command == cmd) return true;
    }
    return false;
  }
  
  string toString(){
    string r = "Supported:\n";
    foreach(ExecProg p; progs){
      if(p.available) r ~= "- " ~ p.name ~ "\n";
    }
    r ~= "Not supported:\n";
    foreach(ExecProg p; progs){
      if(!p.available) r ~= "- " ~ p.name ~ "\n";
    }
    return r;
  }
  
  private:
    ExecProg[] progs;
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
      command = "\"call \"" ~ command ~ "\" " ~ arguments ~"\" > " ~ stdoutfile ~ " 2> "~ stderrfile ~ "\0";    
    }else{
      command = command ~ " " ~ arguments ~ " > " ~ stdoutfile ~ " 2> "~ stderrfile ~ "\0"; 
    }
    ExecResult result;
    if(verbose) writeln("command: " ~ command);
    result.status = system(command.dup.ptr);
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
