module dcmp.procedures;

import dcmp.errors, dcmp.token, dcmp.expressions, dcmp.parser, dcmp.codegen_asm;

/* Structure holding the location and offsets to ebp for function args and local variables*/
struct LocalVEntry{
  string vname;
  int    voffset;
}

/* Parses and pushes supplied arguments to a function call */
void doArgsCallList(ref Parser p, Token func){
  p.matchValue("(");
  if(p.lookAhead.value != ")"){
    p.bexpression();                        // Parse and
    pushRegister();                         // Push the first argument to the function
    while(p.lookAhead.value == ","){
      p.matchValue(",");
      p.bexpression();                      // Parse and
      pushRegister();                       // Push the other argument to the function
    }
  }
  p.matchValue(")");                        // Todo: Match the supplied args with the argumentlist
  callFunction(func.value);                 // Call the function
}

/* Parses the arguments to a function call so that we can dereference when writing the function block */
LocalVEntry[] doArgsDefinitionList(ref Parser p){
  LocalVEntry[] args;
  int offset = 0;
  p.matchValue("(");
  if(p.lookAhead.value != ")"){
    Token  type = p.matchType("type");
    Token  id   = p.matchType("identifier");
    args ~= LocalVEntry(id.value, offset);
    while(p.lookAhead.value == ","){
      p.matchValue(",");
      type    = p.matchType("type");
      id      = p.matchType("identifier");
      offset += 4;                                // TODO: Use sizeOf type
      args   ~= LocalVEntry(id.value, offset);
    }
  }
  p.matchValue(")");
  return args;
}

