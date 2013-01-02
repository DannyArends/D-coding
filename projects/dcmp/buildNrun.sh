rdmd -I../ main.d tests/main.script > asm.out 
nasm -felf asm.out 
gcc asm.o
./a.out 

