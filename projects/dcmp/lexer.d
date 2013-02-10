module dcmp.lexer;

import std.file, std.string, std.stdio;
import dcode.errors;
import dcmp.recognizers, dcmp.token;

alias dcmp.recognizers.isNumeric isNumeric;

/* Wraps character based lexing of a string, allows skipping over newlines and spaces */
struct Lexer{
  this(string input){ this.input = input; }

  char nextChar(){
    advance();
    if(ignoreWhite && isWhite(input[cl])) nextChar();
    if(ignoreNewline && isNewline(input[cl])) nextChar();
    return input[cl];
  }
  
  char currentChar(){ return input[cl]; }

  char advance(){
    cl++;
    if(cl >= input.length) abort("Unexpected end of input");
    return input[cl];
  }

  private:
    string input;
    bool   ignoreWhite = true;
    bool   ignoreNewline = true;
    int    cl = 0;
}

alias bool  function(char) allowedCharFun;

/* Create a token by looking forward and merging allowed characters */
Token createToken(ref Lexer l, string type, allowedCharFun match, int mlength = -1){
  string value;
  while(mlength != 0 && match(l.currentChar())){
    value ~= l.currentChar();
    if(mlength != -1) mlength--;
    l.advance();
  }
  return Token(value, type);
}

Token[] tokenizeString(string s){
  Token[] tokens;
  Lexer l = Lexer(s);
  while(l.currentChar() != EOI){
    char ch = l.currentChar();
    if(isNewline(ch)){
      tokens ~= l.createToken("newline",    &isNewline);
      if(l.ignoreNewline) tokens = tokens[0 .. ($-1)];
    }else if(isWhite(ch)){
      tokens ~= l.createToken("whitespace", &isWhite);
      if(l.ignoreWhite) tokens = tokens[0 .. ($-1)];
    }else if(isOperator(ch)){
      tokens ~= l.createToken("operator",   &isOperator);
    }else if(isNumeric(ch)){
      tokens ~= l.createToken("numeric",    &isNumeric);
    }else if(isDelimiter(ch)){
      tokens ~= l.createToken("delimiter",  &isDelimiter, 1);
    }else if(isCharacter(ch)){
      tokens ~= l.createToken("identifier", &isIdentifier);
      if(isKeyword(tokens[($-1)].value)) tokens[($-1)].type = "keyword";
      if(isType(tokens[($-1)].value)) tokens[($-1)].type = "type";
      if(isBool(tokens[($-1)].value)) tokens[($-1)].type = "boolean";
    }else{
      abort(format("Unknown: %s",l.currentChar()));
    }
  }
  tokens ~= Token("\0","end");
  return(tokens);
}

/* Split a file into tokens */
Token[] tokenizeFile(string fn){
  if(!exists(fn) || !isFile(fn)){ abort("No such file"); }
  return(tokenizeString(chomp(readText(fn)) ~ EOI));
}

