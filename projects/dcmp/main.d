import std.stdio, std.file, std.string;
import dcmp.errors, dcmp.token, dcmp.lexer, dcmp.parser;

// dcmp/tests/main.script

void main(string[] args){
  //writeln("DcMp V0.0.0");

  if(args.length < 2) abort("usage: dcmp src");
  if(!exists(args[1]) || !isFile(args[1])) abort(format("- No such file: %s", args[1]));

  Token[] t = tokenizeFile(args[1]);
  Parser p = Parser(t);
  p.parseProgram();
}

