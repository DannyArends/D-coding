/******************************************************************//**
 * \file src/main/csc.d
 * \brief Caesar subsitution cipher
 *
 * crypted[i] = (text[i] + key) MOD 256
 * text[i]    = (crypted[i] - key) MOD 256
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;

//Encoding a single byte
byte encode(byte x, byte key = 0){
  asm{
    mov   BL, x[EBP]   ; // BL = x
    add   BL, key[EBP] ; // BL = x + key
    mov   AL, BL       ; // AL = BL = x + key
    cdq                ; // QWORD = EAX:EDX
    mov   BX, 256      ; // BX = 256
    idiv  BX           ; // QWORD / BX = AL (Q) : DL (R)
    mov   AL, DL       ; // Return the remainder after division
  }
}

byte[] encode(string text, byte key = 0){
  byte[] crypted;
  foreach(char c;text){ crypted ~= encode(c, key); }
  return crypted;
}

//Decoding a single byte
byte decode(byte x, byte key = 0){
  asm{
    mov   BL, x[EBP]   ; // BL = x
    sub   BL, key[EBP] ; // BL = x - key
    mov   AL, BL       ; // AL = BL = x - key
    cdq                ; // QWORD = EAX:EDX
    mov   BX, 256      ; // BX = 256
    idiv  BX           ; // QWORD / BX = AL (Q) : DL (R)
    mov   AL, DL       ; // Return the remainder after division
  }
}

string decode(byte[] crypted, byte key = 0){
  string text;
  foreach(byte c;crypted){ text ~= cast(char)decode(c, key); }
  return text;
}

void main(string[] args){
  writeln("encode('A') = ",encode('A'));
  writeln("decode(65)  = ",cast(char)decode(65));
  writeln("encode('z') = ",encode('z'));
  writeln("decode(122) = ",cast(char)decode(122));
  writeln("encode(\"Hello world\") = ",encode("Hello world"));
  writeln("decode(encode(\"Hello world\")) = ",decode(encode("Hello world")));
}
