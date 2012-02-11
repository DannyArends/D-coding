module zconf;

const MAX_MEM_LEVEL = 9;
const MAX_WBITS = 15;
alias extern ZEXTERN;

extern (C):
alias ubyte Byte;
alias uint uInt;
alias uint uLong;
alias Byte Bytef;
alias char charf;
alias int intf;
alias uInt uIntf;
alias uLong uLongf;
alias void *voidpc;
alias void *voidpf;
alias void *voidp;

import std.c.types;

const SEEK_SET = 0;
const SEEK_CUR = 1;
const SEEK_END = 2;

alias long z_off_t;
alias z_off_t z_off64_t;
