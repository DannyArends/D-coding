module dcmp.recognizers;

import std.conv;

immutable char EOI = '\0';
immutable string[] types      = [ "char", "short", "int" ];
immutable string[] addOps     = [ "+", "-" ];
immutable string[] mulOps     = [ "*", "/" ];
immutable string[] relOps     = [ "=", "==", "<>", "!", "&", "&&",">=","<=", "|", "||", "<", ">" ];
immutable string[] operators  = addOps ~ mulOps ~ relOps;
immutable string[] delimiters = [ "(", ")", "[", "]", "{", "}", ";", ","];
immutable string[] keywords   = [ "if", "else", "for", "while", "break" ];

bool isKeyword(string s){
  foreach(kw; keywords){ if(s == kw) return true; }
  return false; 
}

bool isType(string s){
  foreach(tp; types){ if(s == tp) return true; }
  return false; 
}

bool isBool(string s){if(s == "true" || s == "false") return true; return false; }

bool isWhite(char ch){
  if(ch == ' ' || ch == '\t') return true;
  return false;
}

bool isNewline(char ch){
  if(ch == '\r' || ch=='\n'){ return true; } 
  return false; 
}

bool isOperator(char ch){
  foreach(op; operators){ if(to!string(ch) == op) return true; }
  return false; 
}

bool isDelimiter(char ch){
  foreach(op; delimiters){ if(to!string(ch) == op) return true; }
  return false; 
}

bool isNumeric(char ch){ 
  if('0' <= ch && ch <= '9'){return true;} 
  if(ch == '.') return true;
  return false; 
}

bool isCharacter(char ch){ 
  if('a' <= ch && ch <= 'z'){ return true;} 
  if('A' <= ch && ch <= 'Z'){ return true; }
  return false; 
}

bool isIdentifier(char ch){ return isCharacter(ch) || isNumeric(ch); }

