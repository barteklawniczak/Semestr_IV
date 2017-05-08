#include <stdio.h>
#include <time.h>

__inline__ unsigned long long rdtsc(void)
{
unsigned long long lo, hi;
__asm__ __volatile__ (
        "xorl %%eax,%%eax \n        cpuid"
        ::: "%rax", "%rbx", "%rcx", "%rdx");
__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
return (unsigned long long)hi << 32 | lo;
}

int funkcjes(char *, ... );
int funkcje(char *, int , float , char, char [] );

int main()
{
	double time;
	unsigned long long x;
	unsigned long long y;
	int a;
	float b;
	char c;
	char d [100];
	x = rdtsc();
	funkcjes("%d %f %c %s", &a, &b, &c, &d);
	y = rdtsc();
	printf("Czas wykonania funkcji scanf: %.3f s\n", (double)(y-x)/(2.6*1000000000));
	x = rdtsc();
	funkcje("%d %f %c %s", a, b, c, d);
	y = rdtsc();
	printf("\nCzas wykonania funkcji printf: %.0f ns\n", (double)(y-x)/(2.6));
	return 0;
}
