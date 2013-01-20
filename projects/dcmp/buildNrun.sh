rdmd -I../ main.d tests/main.script > asm.out 
nasm -felf asm.out 
gcc -m32 asm.o
./a.out 

