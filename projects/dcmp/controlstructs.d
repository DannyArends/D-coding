module dcmp.controlstructs;

import std.stdio;
import dcmp.errors, dcmp.token, dcmp.parser, dcmp.expressions, dcmp.codegen_asm;

void controlStatement(ref Parser p, Token keyword){
  p.nextLabel();
  switch(keyword.value){
    case "if":
      p.matchValue("(");
      p.bexpression();
      p.matchValue(")");
      emitTest(p.getL2());
      p.doBlock(false);
      jmpToLabel(p.getL1(), false);     // Don't check the label, it will be emitted after the else
      addLabel(p.getL2());
      if(p.lookAhead.value == "else"){
        p.matchValue("else");
        p.doBlock(false);
      }
      addLabel(p.getL1());
    break;
    case "while":
      addLabel(p.getL1());
      p.matchValue("(");
      p.bexpression();
      p.matchValue(")");
      emitTest(p.getL2());
      p.doBlock(false);
      jmpToLabel(p.getL1());
      addLabel(p.getL2());
    break;
    default:
      undefined(keyword.value);
    break;
  }
}

