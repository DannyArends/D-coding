import std.stdio, std.math, std.file, std.path, std.string, std.conv;
import std.getopt;
import core.memory;
import core.numbers.entropy;
import io.walkdir;

void main(string[] args){
  bool help    = false;
  bool verbose = false;
  uint depth   = 4;
  string input = ".";
  string output = "entropy.out";
  getopt(args, "help|h", &help
             , "verbose|v", &verbose
             , "depth|d", &depth
             , "output|o", &output
             , "input|i", &input );
  if(!help){
    writefln("Scanning: %s to a depth of %s, saving to %s",input,depth,output);
    auto fp = new File(output,"w");
    scope(exit) fp.close();
    ulong cnts[2] = walkdir(fp, input,[0, 0], depth);
    writefln("Done: %s files / %s dirs", cnts[0], cnts[1]);
  }else{
    writeln("File entropy scanner");
    writeln(" -h(elp)    Show this help");
    writeln(" -i(nput)   Input path: e.g: C:\\");
    writeln(" -io(utput) Filename of the output file");
    writeln(" -d(epth)   Depth of directories");
    writeln("\nExample scan 'c:\\windows' to a depth of 4:");
    writeln(" > entropy.exe -ic:\\\\windows -d4");
  }
}
