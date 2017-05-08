#include <stdio.h>
#include <time.h>

unsigned long long rdtsc()
{
	unsigned long long lo, hi;
	__asm__ __volatile__ (
      	 	 "xorl %%eax,%%eax \n        cpuid"
       		 ::: "%rax", "%rbx", "%rcx", "%rdx");
	__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
return (unsigned long long)hi << 32 | lo;
}
 
void set_fpu(unsigned short a);
void set_sse(unsigned short a);

extern double calka(double, double, double, int, double, double);
extern double calkaxmm(double, double, double, int, double, double);
extern double calkasse(double, double, double, int, double, double);
extern float calkafloat(float, float, float, int, float, float);

unsigned short get_fpu();
unsigned short get_sse();

int main(int argc, char * argv[])
{
	unsigned short int value_set;
	int wybor, wyb;
	double gorny, dolny, krok;
	int n;
	printf("CALKA 1/x\nWpisz dolny pulap calki:\n");
	scanf("%lf", &dolny);
	printf("Wpisz gorny pulap calki:\n");
	scanf("%lf", &gorny);
	if(gorny<dolny)
	{
		printf("Blad przy wprowadzaniu\n");
		return 0;
	}
	printf("Wpisz ile krokow ma miec calka:\n");
	scanf("%d", &n);
	krok = ((gorny - dolny)/(double)n);
	dolny = dolny + krok/2;
	double jeden = 1;
	double zero = 0;
	double wynik;
	unsigned long long x;
	unsigned long long y;


for(int i=0; i<24; i++)
{
	switch(i)
	{
		case 0:
		{
			printf("Round to nearest, double extended:\n");
			value_set = 0x037f;
		}break;
		case 1:
		{
			printf("Round to nearest, double:\n");
			value_set = 0x027f;
		}break;
		case 2:
		{
			printf("Round to nearest, float:\n");
			value_set = 0x007f;
		}break;
		case 3:
		{
			printf("Round to nearest, sse:\n");
			value_set = 0x1f80;
		}break;
		case 4:
		{
			printf("Round to nearest, sse double vector:\n");
			value_set = 0x1f80;
		}break;
 		case 5:
		{
			printf("Round to nearest, sse float vector:\n");
			value_set = 0x1f80;
		}break;
		case 6:
		{
			printf("Round down, extended double:\n");	
			value_set = 0x077f;
		}break;
		case 7:
		{
			printf("Round down, double:\n");
			value_set = 0x067f;
		}break;
		case 8:
		{
			printf("Round down, float:\n");
			value_set = 0x047f;
		}break;
		case 9:
		{
			printf("Round down, sse:\n");
			value_set = 0x3f80;
		}break;
		case 10:
		{
			printf("Round down, sse double vector:\n");
			value_set = 0x3f80;
		}break;
		case 11:
		{
			printf("Round down, sse float vector:\n");
			value_set = 0x3f80;
		}break;
		case 12:
		{
			printf("Round up, extended double:\n");
			value_set = 0x0b7f;
		}break;
		case 13:
		{
			printf("Round up, double:\n");
			value_set = 0x0a7f;
		}break;
		case 14:
		{
			printf("Round up, float:\n");
			value_set = 0x087f;
		}break;
		case 15:
		{
			printf("Round up, sse:\n");
			value_set = 0x5f80;
		}break;
		case 16:
		{
			printf("Round up, sse double vector:\n");
			value_set = 0x5f80;
		}break;
		case 17:
		{
			printf("Round up, sse float vector:\n");
			value_set = 0x5f80;
		}break;
		case 18:
		{
			printf("Round toward zero, extended double:\n");
			value_set = 0x0f7f;
		}break;
		case 19:
		{
			printf("Round toward zero, double:\n");
			value_set = 0x0e7f;
		}break;
		case 20:
		{
			printf("Round toward zero, float: \n");
			value_set = 0x0c7f;
		}break;
		case 21:
		{
			printf("Round toward zero, sse: \n");
			value_set = 0x7f80; 
		}break;
		case 22:
		{
			printf("Round toward zero, sse double vector\n");
			value_set = 0x7f80;
		}break;
		case 23:
		{
			printf("Round toward zero, sse float vector\n");
			value_set = 0x7f80;
		}break;
		default:
			break;
	}
	
	if(i==3 || i==9 || i==15 || i==21)
	{
		set_sse(value_set);
		x = rdtsc();
		wynik = calkaxmm(dolny, gorny, krok, n, jeden, zero);
		y = rdtsc();
	}
	else if(i==4 || i==10 || i==16 || i==22)
	{
		set_sse(value_set);
		x = rdtsc();
		wynik = calkasse(dolny, gorny, krok, n, jeden, zero);
		y = rdtsc();
	}
	else if(i==5 || i==11 || i==17 || i==23)
	{
		set_sse(value_set);
		x = rdtsc();
		wynik = calkafloat(dolny, gorny, krok, n, jeden, zero);
		y = rdtsc();
	}
	else
	{
		set_fpu(value_set);
		printf("%d\n", n);
		x = rdtsc();
		wynik = calka(dolny, gorny, krok, n, jeden, zero);
		y = rdtsc();
	}
	printf("Wynik : %.52lf \n", wynik);
	printf("Czas wykonania obliczenia calki: %.0f ns\n", (double)(y-x)/2.6);
}
    /* Return 0 if exiting normally.
     */
    return 0;
}
