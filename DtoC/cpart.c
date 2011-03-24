#include <stdio.h>

int Process(int Value);
int rt_init();
int rt_term();
void LinuxInit();

int main(){
    int num;

    rt_init(); //Init D library
    LinuxInit(); //Code for linking in Linux

    printf("Enter a number\n");
    scanf("%d", &num);
    int r = Process(num);
    printf("The result is %d\n", r);
    getchar();
    rt_term(); //Terminate D library
}
