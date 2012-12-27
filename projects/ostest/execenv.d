module ostest.execenv;
import dcode.stdinc, dcode.types;
import dcode.executor;

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
      int errl = detector.execute(progs[x].command,progs[x].arguments).std_err.length;
      progs[x].available = (errl != detect+progs[x].command.length);
    }
  }
  
  bool hasCommand(string cmd){
    foreach(ExecProg p; progs){
      if(p.available) if(p.command == cmd) return true;
    }
    return false;
  }
  
  override string toString(){
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

