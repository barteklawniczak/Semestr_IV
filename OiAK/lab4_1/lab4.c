#include <stdio.h>
 
void set_fpu(unsigned short a);

extern double calka(double, double, double, int, double, double);

unsigned short get_fpu();

int main(int argc, char * argv[])
{
	unsigned short int value_set = get_fpu(); 
	int wybor, wyb;
	double gorny, dolny, krok, wynik;
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
	double wynikk;


for(int i=0; i<12; i++)
{
	switch(i)
	{
		case 0:
		{
			printf("Round to nearest, double extended:\n ");
			value_set = 0x037f; 
		}break;
		case 1:
		{
			printf("Round to nearest, double:\n ");
			value_set = 0x027f; 
		}break;
		case 2:
		{
			printf("Round to nearest, float:\n ");
			value_set = 0x007f;
		}break;
		case 3:
		{
			printf("Round down, extended double:\n ");	
			value_set = 0x077f; 
		}break;
		case 4:
		{
			printf("Round down, double:\n ");
			value_set = 0x067f; 
		}break;
		case 5:
		{
			printf("Round down, float:\n ");
			value_set = 0x047f; 
		}break;
		case 6:
		{
			printf("Round up, extended double:\n ");
			value_set = 0x0b7f; 
		}break;
		case 7:
		{
			printf("Round up, double:\n ");
			value_set = 0x0a7f; 
		}break;
		case 8:
		{
			printf("Round up, float:\n ");
			value_set = 0x087f; 
		}break;
		case 9:
		{
			printf("Round toward zero, extended double:\n ");
			value_set = 0x0f7f; 
		}break;
		case 10:
		{
			printf("Round toward zero, double:\n ");
			value_set = 0x0e7f; 
		}break;
		case 11:
		{
			printf("Round toward zero, float: \n");
			value_set = 0x0c7f; 
		}break;
		default:
			break;
	}
	set_fpu(value_set);
	wynikk = calka(dolny, gorny, krok, n, jeden, zero);
	printf("Wynik calki %.52lf \n", wynikk);
}
    /* Return 0 if exiting normally.
     */
    return 0;
}
