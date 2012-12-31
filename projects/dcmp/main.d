import std.stdio;
import dcmp.token, dcmp.lexer, dcmp.parser;

void main(){
  Token[] t = tokenizeFile("dcmp/tests/main.script");
  Parser p = Parser(t);
  p.parseProgram();
}
